import asynchat
import asyncore
import re
import socket

def _watch(func, name):
  def wrapped(self, *args, **kwargs):
    print 'Start: %s' % name
    value = func(self, *args, **kwargs)
    print 'End: %s' % name
    return value
  return wrapped

class IRCUser(object):
  def __init__(self, prefix):
    self.hostmask = prefix
    temp = prefix.split('!')
    temp[1:] = temp[1].split('@')
    self.nick, self.user, self.host = temp

  def __repr__(self):
    return "IRCUser('%s!%s@%s')" % (self.nick, self.user, self.host)

  def __str__(self):
    return self.nick

class IRC(asynchat.async_chat):
  __message_regex = re.compile(
      "^(:(?P<prefix>[^ ]+) +)?(?P<command>[^ ]+)( *(?P<arguments> .+))?")
  
  def __init__(self, nick='', user_name='', real_name=''):
    asynchat.async_chat.__init__(self)
    self.set_terminator('\r\n')
    self.ibuffer = []
    self.nick = nick or 'PythonIRCLib'
    self.user_name = user_name or self.nick
    self.real_name = real_name or self.user_name
    self.users = {}

  def collect_incoming_data(self, data):
    '''Collect incoming data into a buffer for later processing.'''
    self.ibuffer.append(data)

  def found_terminator(self):
    '''Process the complete message stored on the buffer.'''
    message = "".join(self.ibuffer)
    self.ibuffer = []
    self._handle_message(message)

  def get_user(self, hostmask):
    user = self.users.get(hostmask)
    if not user:
      user = IRCUser(hostmask)
      self.users[hostmask] = user
    return user
  
  def _parse_prefix(self, prefix):
    if not prefix:
      return ''
    if prefix[0] == ':':
      prefix = prefix[1:]
    if '@' in prefix:
      return self.get_user(prefix)
    else:
      return prefix

  def _handle_message(self, message):
    '''Handle a IRC message.'''
    match = IRC.__message_regex.match(message)
    sender = self._parse_prefix(match.group('prefix'))
    command = match.group('command').upper()
    arguments = match.group('arguments')

    # The last arg, if prepended by a colon, can have spaces in it, so
    # we try to strip that out first and add it back in if we found it
    potential_args = arguments.strip().split(' :', 1)
    arguments = potential_args[0].strip().split(' ')
    if len(potential_args) == 2:
      arguments.append(potential_args[1])

    handler_name = '_handle_%s' % command
    if hasattr(self, handler_name):
      try:
        getattr(self, handler_name)(sender, arguments)
      except:
        print '!@!@!: %s' % message
        raise
    else:
      '###: %s' % message

  def _handle_PING(self, sender, arguments):
    self._send_command('PONG', ' '.join(arguments))

  def _handle_NOTICE(self, sender, arguments):
    target, message = arguments
    self.on_notice(target, sender, message)

  def _handle_PRIVMSG(self, sender, arguments):
    target, message = arguments
    if target == self.nick:
      self.on_private_message(sender, message)
    else:
      self.on_message(target, sender, message)

  def _handle_433(self, sender, arguments):
    '''ERR_NICKNAMEINUSE: a nick change failed because the nick is taken.'''
    self.change_nick(self.nick + '_')

  def _send_command(self, *args):
    command = ' '.join(args)
    self.push('%s\r\n' % command)

  def change_nick(self, new_nick):
    self.nick = new_nick
    self._send_command('NICK', new_nick)

  def set_mode(self, target, mode):
    self._send_command('MODE', target, mode)

  def _send_USER(self):
    self._send_command(
        'USER',
        self.user_name,
        'localhost',
        'localhost',
        ':%s' % self.real_name)

  def connect(self, host, port=6667, password=''):
    self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
    asynchat.async_chat.connect(self, (host, port))
    self.change_nick(self.nick)
    self._send_USER()
  
  def join(self, channel, password=''):
    self._send_command('JOIN', channel, password)

  def send_message(self, target, message):
    self._send_command('PRIVMSG', str(target), message)

  # callbacks
  def on_connect(self):
    pass

  def on_notice(self, target, sender, message):
    pass

  def on_message(self, channel, sender, message):
    pass

  def on_private_message(self, sender, message):
    pass


