from cypy import minecraft
import optparse
import random
import thread
import time

class FancyClient(minecraft.AdminClient):
  def on_logged_in(self, user):
    users = ', '.join(self.users - set([user]))
    self.send_command('say Other players online: %s' % users)

  def on_user_command(self, user, command, args):
    if command == 'list':
      users = ', '.join(self.users)
      self.send_command('say Players online: %s' % users)
    elif command == 'stuck':
      targets = list(self.users - set([user]))
      if len(targets) == 0:
        self.send_command(
            "say Sorry, can't unstuck you if you're the only one online.")
        return
      target = random.choice(targets)
      self.send_command('tp %s %s' % (user, target))
    
  def on_unknown_line(self, line):
    pass
  
  def on_ready(self):
    thread.start_new(self._get_input, ())

  def _get_input(self):
    while True:
      command = raw_input('> ')
      client.send_command(command)

if __name__ == '__main__':
  parser = optparse.OptionParser()
  parser.add_option(
      '-s', '--secret',
      help='shared secret between servers and clients')
  parser.add_option(
      '-n', '--host', default='localhost',
      help='host to connect to')
  parser.add_option(
      '-p', '--port', type='int', default=None,
      help='port to listen/connect on')
  options, args = parser.parse_args()
  client = FancyClient()
  client.connect(secret=options.secret, host=options.host, port=options.port)
