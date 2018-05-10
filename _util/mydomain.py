# -*- coding: utf-8 -*-
"""
    A custom domain for TermySequence actions.

    :copyright: Copyright 2007-2011 by the Sphinx team, see AUTHORS.
    :license: BSD, see LICENSE for details.
"""

import re

from sphinx import addnodes
from sphinx.domains import Domain, ObjType
from sphinx.locale import l_, _
from sphinx.directives import ObjectDescription
from sphinx.roles import XRefRole, emph_literal_role
from sphinx.util.nodes import make_refnode


action_sig_re = re.compile(r'(.+?) +(.*)$')
setting_sig_re = re.compile(r'(.+?)/(.+?) +(.+)$')


class TermyMarkup(ObjectDescription):
    """
    Description of generic TermySequence markup.
    """

    def get_index_text(self, objectname, name):
        if self.objtype == 'action':
            return (_('%s (action)') % name, name[0])
        elif self.objtype == 'protocol':
            return (_('%s (protocol)') % name, name[0])

        titletype = self.objtype.title()
        return (_('%s:%s (%s setting)') % (titletype, name, self.objtype), titletype[0])

    def add_target_and_index(self, name, sig, signode):
        # targetname = self.objtype + '-' + name
        targetname = name
        if targetname not in self.state.document.ids:
            signode['names'].append(targetname)
            signode['ids'].append(targetname)
            signode['first'] = (not self.names)
            self.state.document.note_explicit_target(signode)

            objects = self.env.domaindata['termy']['objects']
            key = (self.objtype, name)
            if key in objects:
                self.env.warn(self.env.docname,
                              'duplicate description of %s %s, ' %
                              (self.objtype, name) +
                              'other instance in ' +
                              self.env.doc2path(objects[key]),
                              self.lineno)
            objects[key] = self.env.docname
        indextext, indexchar = self.get_index_text(self.objtype, name)
        if indextext:
            self.indexnode['entries'].append(('single', indextext,
                                              targetname, '', indexchar))


def parse_action(d):
    """Parse an action signature.

    Returns (action, arguments) string tuple.  If no arguments are given,
    returns (action, '').
    """
    action = d.strip()
    m = action_sig_re.match(action)
    if not m:
        return (action, '')
    parsed_action, parsed_args = m.groups()
    return (parsed_action, ' ' + parsed_args)


def parse_setting(d):
    """Parse a setting signature.

    Returns (name, key, type) string tuple.
    """
    setting = d.strip()
    m = setting_sig_re.match(setting)
    if not m:
        return (setting, '')
    parsed_category, parsed_key, parsed_type = m.groups()
    return ('%s/%s' % (parsed_category, parsed_key), parsed_key, ' (%s)' % parsed_type)


class TermyAction(TermyMarkup):
    """
    Description of a qtermy action.
    """
    def handle_signature(self, sig, signode):
        name, args = parse_action(sig)
        signode += addnodes.desc_name(name, name)
        if len(args) > 0:
            signode += addnodes.desc_addname(args, args)
        return name


class TermySetting(TermyMarkup):
    """
    Description of a qtermy setting.
    """
    def handle_signature(self, sig, signode):
        name, key, typ = parse_setting(sig)
        signode += addnodes.desc_name(key, key)
        signode += addnodes.desc_addname(typ, typ)
        return name


def TermyParam(typ, rawtext, text, lineno, inliner, options={}, content=[]):
    node = addnodes.desc_addname(rawtext, text)
    return [node], []


class TermyDomain(Domain):
    """TermySequence domain."""
    name = 'termy'
    label = 'TermySequence'

    object_types = {
        'action': ObjType(l_('action'), 'action'),
        'protocol': ObjType(l_('protocol'), 'protocol'),
        'global': ObjType(l_('global'), 'global'),
        'profile': ObjType(l_('profile'), 'profile'),
        'theme': ObjType(l_('theme'), 'theme'),
        'alert': ObjType(l_('alert'), 'alert'),
        'launcher': ObjType(l_('launcher'), 'launcher'),
        'connection': ObjType(l_('connection'), 'connection'),
        'server': ObjType(l_('server'), 'server'),
    }
    directives = {
        'action': TermyAction,
        'protocol': TermyAction,
        'global': TermySetting,
        'profile': TermySetting,
        'theme': TermySetting,
        'alert': TermySetting,
        'launcher': TermySetting,
        'connection': TermySetting,
        'server': TermySetting,
    }
    roles = {
        'action': XRefRole(),
        'protocol': XRefRole(),
        'param': TermyParam,
        'global': XRefRole(),
        'profile': XRefRole(),
        'theme': XRefRole(),
        'alert': XRefRole(),
        'launcher': XRefRole(),
        'connection': XRefRole(),
        'server': XRefRole(),
    }
    initial_data = {
        'objects': {},  # fullname -> docname, objtype
    }

    def clear_doc(self, docname):
        for (typ, name), doc in list(self.data['objects'].items()):
            if doc == docname:
                del self.data['objects'][typ, name]

    def get_tooltip_text(self, objtype, target):
        if objtype == 'action':
            return _('%s action') % target
        elif objtype == 'protocol':
            return _('%s protocol') % target
        else:
            return _('%s %s setting') % (target, objtype)

    def resolve_xref(self, env, fromdocname, builder, typ, target, node,
                     contnode):
        objects = self.data['objects']
        objtypes = self.objtypes_for_role(typ)
        for objtype in objtypes:
            if (objtype, target) in objects:
                return make_refnode(builder, fromdocname,
                                    objects[objtype, target],
                                    # objtype + '-' + target,
                                    target, contnode,
                                    self.get_tooltip_text(objtype, target))

    def get_objects(self):
        for (typ, name), docname in self.data['objects'].items():
            # yield name, name, typ, docname, typ + '-' + name, 1
            yield name, name, typ, docname, name, 1
