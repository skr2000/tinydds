# -*- python -*-
#                           Package   : omniidl
# nesc.py                Created on: 2008/3/16
#			    Author    : Pruet Boonma (lulu)
#
#    Copyright (C) 2008 University of Massachusetts Boston
#
#  This file is part of omniidl.
#
#  omniidl is free software; you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
#  02111-1307, USA.
#
# Description:
#   
#   Back-end which exports nesC


# $Id: nesc.py,v 1.4 2008-08-11 19:49:34 pruet Exp $
# $Log: nesc.py,v $
# Revision 1.4  2008-08-11 19:49:34  pruet
# spanning tree work
#
# Revision 1.2  2008-06-25 16:15:28  pruet
#
# complete infrastructure
#
# Revision 1.1  2008-06-11 20:39:15  pruet
# nesc.py for omniorb
#
# Revision 1.1  2008/06/11 20:40:07  pruet
# Initial revision
#
# Revision 1.5  2008/04/26 22:06:22  pruet
# seem to work fine, before moving to template
#
# Revision 1.4  2008/04/07 05:24:03  pruet
# old template
#
# Revision 1.6  2008/03/25 19:13:42  pruet
# Fixed problem for interface with char * type
#
# Revision 1.5  2008/03/25 03:02:08  pruet
# Remove the inherit code, change class type to uint16_t
#
# Revision 1.4  2008/03/24 06:13:30  pruet
# Generating correct code now, cleaned, will move on to nesc
#
# Revision 1.3  2008/03/21 22:35:30  pruet
# First working revision, generating XML
#
# Revision 1.2  2008/03/21 22:19:02  pruet
# Initial revision
#
# Revision 1.1  2008/03/17 23:35:58  pruet
# Cleaning out unnecessary code.
#
#

#TODO:
# Change to template?
# 

"""Export nesC code from IDL"""

from omniidl import idlast, idltype, idlutil, idlvisitor, output
from xml.sax import ContentHandler, saxutils, make_parser
from xml.sax.handler import feature_namespaces
import sys, string, os, getopt

componentSuffix = 'M'

class confHandler (ContentHandler):
	"""Configuration XML parser class"""
	def __init__(self):
		"""Constructor"""
		self.components = []
		self.interfaces = {}
		self.connections = []
		self.dotStar = []
		self.headers = []
		self.stdctrl = []
		self.skipintf = []
		self.eventParameters = {}
		self.eventReturn = {}
		self.commandParameters = {}
		self.commandReturn = {}
		self.event_name = ''
		self.event_component = ''
		self.implementations = {}
		self.conditions = {}
		self.makefile = []
	
	def startElement(self, name, attrs):
		"""XML element start tag"""
		
		if name == 'system-configuration':
			_suffix = attrs.get('componentSuffix', '')
			if _suffix != '':
				componentSuffix = _suffix
		if name == 'configuration':
			_threading = attrs.get('threading', '')
			_platform = attrs.get('platform', '')
			if _threading != '':
				self.conditions['threading'] = _threading
			if _platform != '':
				self.conditions['platform'] = _platform
		elif name == 'component':
			_name = attrs.get('name', '')
			_interface = attrs.get('interface', '')
			#FIXME 
			_condition = attrs.get('condition', '').split('=')
			_makefile = attrs.get('makefile', '')
			if _makefile != '':
				self.makefile.append(_makefile)
			if _condition[0] != '' and self.conditions[_condition[0]] != _condition[1]:
				return
			if name != '':
				if _name not in self.components:
					self.components.append(_name)
				if _interface != '':
					self.interfaces[_interface] = _name
				if attrs.get('stdctrl', '').lower() == 'false':
					self.stdctrl.append(_name)
		elif name == 'connection':
			_from = attrs.get('from', '')
			_to = attrs.get('to', '')
			if _from != '' and _to != '':
				if _to == '*':
					self.dotStar.append(_from)
				else:
					self.connections.append({'from':_from, 'to':_to})
		elif name == 'header' :
			_name = attrs.get('name', '')
			if _name != '':
				self.headers.append(_name)
		elif name == 'skip-interface':
			_name = attrs.get('name', '')
			if _name != '':
				self.skipintf.append(_name)
		elif name == 'event':
			self.event_name = attrs.get('name', '')
			self.event_component = attrs.get('interface', '')
			self.event_return = attrs.get('return', '')
			self.parameter = []
		elif name == 'event-parameter':
			_desc = attrs.get('desc', '')
			if _desc != '':
				self.parameter.append(_desc)
		elif name == 'command':
			self.event_name = attrs.get('name', '')
			self.event_component = attrs.get('interface', '')
			self.event_return = attrs.get('return', '')
			self.parameter = []
		elif name == 'command-parameter':
			_desc = attrs.get('desc', '')
			if _desc != '':
				self.parameter.append(_desc)
		elif name == 'implementation':
			_component = attrs.get('component', '')
			_interface = attrs.get('interface', '')
			if _component != '' and _interface != '':
				self.implementations[_interface] = _component
	def endElement(self, name):
		#FIXME: the index shouldbe event_name:component_name
		if name == 'event':
			if self.event_name != '' and self.event_component != '':
				self.eventParameters[self.event_name + ':' + self.event_component] = self.parameter
				self.eventReturn[self.event_name + ':' + self.event_component] = self.event_return
		elif name == 'command':
			if self.event_name != '' and self.event_component != '':
				self.commandParameters[self.event_name + ':' + self.event_component] = self.parameter
				self.commandReturn[self.event_name + ':' + self.event_component] = self.event_return
	def error(self, exception):
		sys.stderr.write('%s \n', exception)
	def getContents(self):
		return {'components':self.components, 'interfaces':self.interfaces, 'connections':self.connections, 'dotStar':self.dotStar, 'headers':self.headers, 'stdctrl':self.stdctrl, 'skipintf':self.skipintf, 'eventparams':self.eventParameters, 'eventreturn':self.eventReturn, 'implementations':self.implementations, 'conditions':self.conditions, 'makefile':self.makefile, 'commandparams':self.commandParameters, 'commandreturn':self.commandReturn}
		
class NesCVisitor (idlvisitor.AstVisitor, idlvisitor.TypeVisitor):
	nesc_ext = '.nc'
	h_ext = '.h'
	def __init__(self, st, tree, _debug, skeleton, confHash):
		self.st = st
		self.tree = tree
		self._debug = _debug
		self.components = confHash['components']
		self.interfaces = confHash['interfaces']
		self.connections = confHash['connections']
		self.dotStar = confHash['dotStar']
		self.headers = confHash['headers']
		self.skeleton = skeleton
		self.stdctrl = confHash['stdctrl']
		self.skipintf = confHash['skipintf']
		self.eventParameters = confHash['eventparams']
		self.eventReturn = confHash['eventreturn']
		self.commandParameters = confHash['commandparams']
		self.commandReturn = confHash['commandreturn']
		self.implementations = confHash['implementations']
		self.conditions = confHash['conditions']
		self.makefile = confHash['makefile']
		self.typedef = []
		self.const = []
		self.struct = []
		self.enum = []
		self.inherit = {}
		self.module = ''
		self.operations = {}
		self.structlist = []
		
		#FIXME
		self.firstRound = True
		
	def debug(self, str):
		if self._debug:
			self.st.out(str)

	def visitAST(self, node):
		for n in node.declarations():
			n.accept(self)

	def visitModule(self, node):
		moduleName = node.identifier()
		self.module = moduleName
		self.debug('Start generating module ' + moduleName)
		
		# run through all AST, for gathering information about header file
		for n in node.definitions():
			n.accept(self)			
		self.firstRound = False
		for n in node.definitions():
			n.accept(self)
			
		self.interfaces['Application'] = 'Application' + componentSuffix
		
		# Handle all typedef
		self.debug('\tStart generating typedef')
		f = open(moduleName + '_type' + self.h_ext, 'w')
		stTypedef = output.Stream(f, 2);
		# FIXME: how to handler forwarder ?
		for i in self.interfaces:
			stTypedef.out('typedef uint16_t @interface@_t;', interface = i)
		for i in self.skipintf:
			stTypedef.out('typedef uint16_t @interface@_t;', interface = i)
		stTypedef.out('\n')
		for t in self.typedef:
			stTypedef.out(t)
		f.close()
		self.debug('\tFinish generating typedef\n')
	
		# Handle all const
		# TODO: put the copyright and condition check here(ifndef)
		self.debug('\tStart generating const')
		f = open(moduleName + '_const' + self.h_ext, 'w')
		stCons = output.Stream(f, 2);
		for t in self.const:
			stCons.out(t)
		f.close()
		self.debug('\tFinish generating const\n')
		
		# Handle struct
		self.debug('\tStart generating struct')
		f = open(moduleName + '_struct' + self.h_ext, 'w')
		stStruct = output.Stream(f, 2);
		for t in self.struct:
			stStruct.out(t)
		f.close()
		self.debug('\tFinish generating struct\n')
		
		# Handle enum
		self.debug('\tStart generating enum')
		f = open(moduleName + '_enum' + self.h_ext, 'w')
		stEnum = output.Stream(f, 2);
		for t in self.enum:
			stEnum.out(t)
		f.close()
		self.debug('\tFinish generating enum\n')
		
		# Then generate the module file
		# TODO: Some kind of template here?
		f = open(moduleName + self.nesc_ext, 'w')
		stConf = output.Stream(f, 2)
		stConf.out('''//$Id: nesc.py,v 1.4 2008-08-11 19:49:34 pruet Exp $

/*Copyright (c) 2008 University of Massachusetts, Boston 
All rights reserved. 
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
Neither the name of the University of Massachusetts, Boston  nor 
the names of its contributors may be used to endorse or promote products 
derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY OF
MASSACHUSETTS, BOSTON OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
*/
		''')
		stConf.out('//This file is generated from @name@ by omniidl (nesC backend)- omniORB_4_1. Do not edit manually.', name = self.tree.file())
		stConf.out('//Header block')
		if len(self.enum) > 0:
			stConf.out('includes @name@_enum;', name = moduleName)
		if len(self.typedef) > 0:
			stConf.out('includes @name@_type;', name = moduleName)
		if len(self.struct) > 0:
			stConf.out('includes @name@_struct;', name = moduleName)
		if len(self.const) > 0:
			stConf.out('includes @name@_const;', name = moduleName)
		if len(self.headers) > 0:
			for h in self.headers:
				stConf.out('includes @name@;', name = h)

		stConf.out('//Configuration block')
		stConf.out('configuration @id@ {', id = moduleName)
		stConf.out('}\n')
		stConf.out('//Implementation block')
		stConf.out('implementation {')
		for i in self.interfaces.keys():
			if self.interfaces[i] not in self.components and i not in self.implementations.keys():
				self.components.append(self.interfaces[i])
		for i in self.implementations.keys():
			self.components.remove(i)
			if self.implementations[i] not in self.components:
				self.components.append(self.implementations[i])
		stConf.out('\tcomponents ' + string.join(self.components, ', ') + ';\n')
		for s in self.dotStar:
			for c in self.components:
				if c != s.split('.')[0] and c not in self.stdctrl and c in self.components:
					if c in self.implementations.keys():
						c = self.implementations[c]
					stConf.out('\t@fr@ -> @to@;', fr = s, to = c)
		for pair in self.connections:
			c = pair['to']
			s = pair['from']
			if c.split('.')[0] in self.components and s.split('.')[0] in self.components:
				if c.split('.')[0] in self.implementations.keys():
					c = self.implementations[c.split('.')[0]] + '.' + c.split('.')[1]
				if s.split('.')[0] in self.implementations.keys():
					s = self.implementations[s.split('.')[0]] + '.' + s.split('.')[1]
				stConf.out('\t@fr@ -> @to@;', fr = s, to = c)
			if c.split('.')[0] in self.implementations.keys() and s.split('.')[0] in self.components:
				c = self.implementations[c.split('.')[0]]# + '.' + c.split('.')[1]
				stConf.out('\t@fr@ -> @to@;', fr = s, to = c)
			if s.split('.')[0] in self.implementations.keys() and c.split('.')[0] in self.components:
				s = self.implementations[s.split('.')[0]] + '.' + s.split('.')[1]
				stConf.out('\t@fr@ -> @to@;', fr = s, to = c)
				
				
		for i in self.interfaces:	
			self.debug('\tStart generating interface ' + i)
			fi = open(i + self.nesc_ext, 'w')
			stIntf = output.Stream(fi, 2)
			stIntf.out('''//$Id: nesc.py,v 1.4 2008-08-11 19:49:34 pruet Exp $

/*Copyright (c) 2008 University of Massachusetts, Boston 
All rights reserved. 
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

	Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
	Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
    Neither the name of the University of Massachusetts, Boston  nor 
the names of its contributors may be used to endorse or promote products 
derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY OF
MASSACHUSETTS, BOSTON OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
*/
			''')
			stIntf.out('//This file is generated from IDL/Configuration. Do not edit manually')
			if i in self.stdctrl:
				provides = []
			else:
				provides = ['StdControl']
			uses = []
		
			for pair in self.connections:
				if pair['from'].split('.')[0] == self.interfaces[i]:
					if pair['from'].split('.')[1] not in uses:
						uses.append(pair['from'].split('.')[1])
				if pair['to'].split('.')[0] == self.interfaces[i]:
					if len(pair['from'].split('.')) > 1:
						if pair['from'].split('.')[1] not in provides:
							provides.append(pair['from'].split('.')[1])
					elif pair['from'] not in provides:
						provides.append(pair['from'])
			if self.inherit.has_key(i):
				stIntf.out('//Ancestors List:')
				for ih in self.inherit[i]:
					if ih not in uses:
						#uses.append(ih)
						stIntf.out('//\t@name@', name = ih)
			if i not in provides:
				provides.append(i)
			stIntf.out('interface ' + i + ' {')
			if self.skeleton:
				cname = self.interfaces[i]
				#cname = i + componentSuffix
				if cname in self.implementations.keys():
					cname = self.implementations[cname]
				mi = open(cname + self.nesc_ext, 'w')
				stMod = output.Stream(mi, 2)
				stMod.out('//This file is generated from IDL/Configuration. please use it as the skelton file for your module')				
				if self.inherit.has_key(i):
					stMod.out('//Ancestors List:')
					for ih in self.inherit[i]:
						stMod.out('//\t@name@', name = ih)
				stMod.out('module @name@ {', name = cname)
				stMod.out('\tprovides {')
				#stMod.out('\t\t interface @interface@;', interface = i)
				if len(provides) > 0:
					for p in provides:
						stMod.out('\t\tinterface @interface@;', interface = p)
				stMod.out('\t}')
				if len(uses) > 0:
					stMod.out('\tuses {')
					for u in uses:
						stMod.out('\t\tinterface @interface@;', interface = u)
					stMod.out('\t}')
				stMod.out('}')
				stMod.out('implementation {')
				
			#FIXME
			if self.skeleton:
				stMod.out('\tcommand result_t StdControl.init ()\n\t{\n\t}\n')
				stMod.out('\tcommand result_t StdControl.start ()\n\t{\n\t}\n')
				stMod.out('\tcommand result_t StdControl.stop ()\n\t{\n\t}\n')
			empty = True;
			if self.operations.has_key(i):
				empty = False;
				for o in self.operations[i]:
					stIntf.out('\tcommand  @op@;', op = o)
					if self.skeleton:
						opa = o.split(' ')
						if opa[1] == '*':
							stMod.out('\tcommand @ret@* @interface@.@op@\n\t{\n\t}\n', ret = opa[0], interface = i, op = string.join(opa[2:], ' '))
						else:
							stMod.out('\tcommand @ret@ @interface@.@op@\n\t{\n\t}\n', ret = opa[0], interface = i, op = string.join(opa[1:], ' '))
			for ec in self.commandReturn.keys():
				if i == ec.split(':')[1]:
					empty = False;
					params_list = []
					for p in self.commandParameters[ec]:
						params_list.append(p)
					stIntf.out('\tcommand %s %s (%s);' % (self.commandReturn[ec], ec.split(':')[0], string.join(params_list, ', ')))
			for ec in self.eventReturn.keys():
				if i == ec.split(':')[1]:
					empty = False;
					params_list = []
					for p in self.eventParameters[ec]:
						params_list.append(p)
					stIntf.out('\tevent %s %s (%s);' % (self.eventReturn[ec], ec.split(':')[0], string.join(params_list, ', ')))
			if self.skeleton:		
				for ec in self.commandReturn.keys():
					if i == ec.split(':')[1]:
						params_list = []
						for p in self.commandParameters[ec]:
							params_list.append(p)
						stMod.out('\tcommand %s %s.%s (%s) \n\t{\n\t}\n' % (self.commandReturn[ec], ec.split(':')[1], ec.split(':')[0], string.join(params_list, ', ')))
				for u in uses:
					for ec in self.eventReturn.keys():
						if u == ec.split(':')[1]:
							params_list = []
							for p in self.eventParameters[ec]:
								params_list.append(p)
							stMod.out('\tevent %s %s.%s (%s) \n\t{\n\t}\n' % (self.eventReturn[ec], ec.split(':')[1], ec.split(':')[0], string.join(params_list, ', ')))
				
			if empty:
				stIntf.out(';')
			if self.inherit.has_key(i):
				for ih in self.inherit[i]:
					if self.operations.has_key(ih):
						for o in self.operations[ih]:
							stIntf.out('\t//Inherited from @name@', name = ih)
							stIntf.out('\tcommand  @op@;', op = o)
							if self.skeleton:
								stMod.out('\t//Inherited from @name@', name = ih)
								opa = o.split(' ')
								if opa[1] == '*':
									stMod.out('\tcommand @ret@* @interaface@.@op@\n\t{\n\t}', ret = opa[0], interaface = i, op = string.join(opa[2:], ' '))
								else:
									stMod.out('\tcommand @ret@ @interaface@.@op@\n\t{\n\t}', ret = opa[0], interaface = i, op = string.join(opa[1:], ' '))
			stIntf.out('}')	
			if self.skeleton:
				stMod.out('}')
			self.debug('\tFinish generating interface ' + i + '\n')
		stConf.out('}');
		self.debug('Finish generating module ' + moduleName)
		f.close()

	def visitInterface(self, node):
		interfaceName = node.identifier()
		if interfaceName in self.skipintf:
			return
		if self.firstRound:
			self.interfaces[interfaceName] = interfaceName + componentSuffix
		else:
			inheritl = []
			if len(node.inherits()) != 0:
				for i in node.inherits():
					inheritl.append(i.identifier())
			self.inherit[interfaceName] = inheritl
			self.interfaceOp = []
			for n in node.contents():
				n.accept(self)
			if len(self.interfaceOp) > 0:
				self.operations[interfaceName] = self.interfaceOp
			self.interfaces[interfaceName] = interfaceName + componentSuffix
		
	def visitOperation(self, node):
		node.returnType().accept(self)
		rtype = self.__result_type
		paraml = []
		for p in node.parameters():
			p.paramType().accept(self)
			type = self.__result_type
			if self.interfaces.has_key(type) or type in self.skipintf:
				paraml.append(type + '_t ' + p.identifier())
			else:
				paraml.append(type + ' ' + p.identifier())
		params = string.join(paraml, ', ')
		#TODO: Exception Raises
		if self.interfaces.has_key(rtype) or rtype in self.skipintf:
			s = rtype + '_t ' + node.identifier() + ' (' + params + ')'
		else:
			s = rtype + ' ' + node.identifier() + ' (' + params + ')'
		self.interfaceOp.append(s);

	def visitStruct(self, node):
		if not self.firstRound:
			u = ''
			s = 'typedef struct {\n'
			for m in node.members():
				m.memberType().accept(self)
				type = self.__result_type
				if type.startswith('sequence'):
					type_r = self.__result_type.split(',')
					decll = []
					t = ''
					for d in m.declarators():
						d.accept(self)
						decll.append(self.__result_declarator)
					u += 'struct {\n\t\tuint _length;\n\t\t'
					u += type_r[1] + '* _buffer;\n'
					u += '\t} ' + string.join(decll, ', ') + ';' + '\n'
					s = s + '\t' + u 
				else:
					decll = []
					for d in m.declarators():
						d.accept(self)
						decll.append(self.__result_declarator)
					decls = string.join(decll, ', ')
					s = s + '\t' + type + ' ' + decls + ';\n'
			s += '} ' + node.identifier() + ';\n'
			self.struct.append(s)
			self.structlist.append(node.identifier())

	def visitTypedef(self, node):
		if not self.firstRound:
			if node.constrType():
				con.aliasType().decl().accept(self)
		
			node.aliasType().accept(self)
			type = self.__result_type
			# this is a hack, need to find a better way to handle this
			if type.startswith('sequence'):
				decll = []
				t = ''
				for d in node.declarators():
					d.accept(self)
					decll.append(self.__result_declarator)
				s = 'typedef struct {\n\tuint _length;\n\t'
		
				type_r = self.__result_type.split(',')

				# if type_r[1] == 'Topic':
				# 	print self.interfaces.has_key(type_r[1])
				# 	print type_r[1]
				# 	print self.interfaces
				if type_r[1] in self.structlist:
					s += 'struct '
				if self.interfaces.has_key(type_r[1]) or type_r[1] in self.skipintf:	
					s += type_r[1] + '_t* _buffer;\n'
				else:	
					s += type_r[1] + '* _buffer;\n'
				s += '} ' + string.join(decll, ', ') + ';' + t + '\n'
				self.typedef.append(s)
			else:
				decll = []
				for d in node.declarators():
					d.accept(self)
					decll.append(self.__result_declarator)

				decls = string.join(decll, ', ')
				self.typedef.append('typedef ' + type + ' ' + decls + ';\n');
		
	def visitEnum(self, node):
		if not self.firstRound:
			s = 'enum {\n'
			enuml = []
			for e in node.enumerators():
				enuml.append('\t' + e.identifier())
			s += string.join(enuml, ',\n') + '\n};\n'
			s += '#define ' + node.identifier() + ' uint8_t\n'
		
			self.enum.append(s)
		
	def visitConst(self, node):
		if not self.firstRound:
			node.constType().accept(self)
			type = self.__result_type

			if node.constKind() == idltype.tk_string:
				value = '"' + idlutil.escapifyString(node.value()) + '"'
			elif node.constKind() in [idltype.tk_float, idltype.tk_double, idltype.tk_longdouble]:
				value = idlutil.reprFloat(node.value())

			else:
				value = str(node.value())

			self.const.append('const ' + type + ' ' + node.identifier() + ' = ' + value + ';\n')


	def visitDeclarator(self, node):
		l = [node.identifier()]
		for s in node.sizes():
			l.append('[' + str(s) + ']')
		self.__result_declarator = string.join(l, '')
	ttsMap = {
		idltype.tk_void:       'void',
		idltype.tk_short:      'uint16_t',
		idltype.tk_long:       'uint32_t',
		idltype.tk_ushort:     'uint16_t',
		idltype.tk_ulong:      'uint32_t',
		idltype.tk_float:      'float',
		idltype.tk_double:     'double',
		idltype.tk_boolean:    'bool',
		idltype.tk_char:       'uint8_t',
		idltype.tk_octet:      'uint8_t',
		idltype.tk_longlong:   'uint64_t',
		idltype.tk_ulonglong:  'uint64_t',
		idltype.tk_longdouble: 'long double',
	}

	def visitBaseType(self, type):
		self.__result_type = self.ttsMap[type.kind()]

	def visitStringType(self, type):
		self.__result_type = 'char *'

	def visitSequenceType(self, type):
		type.seqType().accept(self)
		self.__result_type = 'sequence,' + self.__result_type

	def visitDeclaredType(self, type):
		self.__result_type = type.decl().identifier()
		
def generateMakefile(platform, mkfile):
	makefile = open('Makefile', 'w')
	#Should m
	if platform != '':
		makefile.write('PLATFORMS=%s\n' % platform)
	makefile.write("""COMPONENT ?= DDS
#PFLAGS += -I%T/platform/pc/CC1000Radio
#MSG_SIZE=75
""")
	for m in mkfile:
		makefile.write('include %s\n' % m)
	makefile.write('include ../Makerules')

def run(tree, args):
	debug = False
	genMakefile = False
	skeleton = False
	for a in args:
		if a.find('d', 0, 1) != -1:
			debug = True
		elif a.find('c', 0, 1) != -1:
			confFile = a.split('=')[1]
		elif a.find('m', 0, 1) != -1:
			getMakefile = True
		elif a.find('s', 0, 1) != -1:
			skeleton = True
	parser = make_parser()
	parser.setFeature(feature_namespaces, 0)

	#Process the conf file first
	handler = confHandler()
	parser.setContentHandler(handler)
	parser.parse(confFile)
	confHash = handler.getContents()
	#if args.count('debug') > 0:
	#	debug = True
	
	
	st = output.Stream(sys.stdout, 2)
	nv = NesCVisitor(st, tree, debug, skeleton, confHash)
	tree.accept(nv)
	
	if getMakefile:
		generateMakefile(confHash['conditions'].get('platform', ''), confHash['makefile'])
		
		
