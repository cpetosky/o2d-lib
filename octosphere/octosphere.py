import asyncore
import irclib
import thread

class CommandProcessor(object):
  def __init__(self):
    self._prefix = ''
    self._commands = {}
    for attr_name in dir(self):
      if attr_name.startswith('handle_'):
        self._commands[attr_name[len('handle_'):]] = getattr(self, attr_name)

  def default_handler(self, bot):
    pass

  def handle(self, bot, message):
    if message.startswith(self._prefix):
      message = message[len(self._prefix):]
    
    if not message:
      self.default_handler(bot)
      return True

    command, rest = (message.split(' ', 1) + [''])[:2]
    if command in self._commands:
      return self._commands[command](bot, rest)
    return False

class DefaultCommandProcessor(CommandProcessor):
  def handle_joinchannel(self, bot, message):
    channel, password = (message.split(' ', 1) + [''])[:2]
    bot.join(channel, password)
    return True

class Octosphere(irclib.IRC):
  def __init__(self, nick='Octosphere', user_name='', real_name=''):
    irclib.IRC.__init__(self, nick, user_name, real_name)
    self.processors = [DefaultCommandProcessor()]

  def start(self, host='', port=6667, password=''):
    if host:
      self.connect(host, port, password)
    asyncore.loop()
  
  def on_connect(self):
    self.set_mode(self.nick, '+B')
    pass

  def on_notice(self, target, sender, message):
    print '-- %s:%s: %s' % (sender, target, message)

  def on_message(self, channel, sender, message):
    pass

  def on_private_message(self, sender, message):
    for processor in self.processors:
      if processor.handle(self, message):
        return

if __name__ == '__main__':
  bot = Octosphere()
  thread.start_new(bot.start, ('irc.synirc.net',))

  while True:
    try:
      command = raw_input('')
    except (EOFError, KeyboardInterrupt):
      break
    else:
      bot.push('%s\r\n' % command)
