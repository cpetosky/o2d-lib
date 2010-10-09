from cypy import minecraft
import random
import sys

class FancyClient(minecraft.AdminClient):
  def on_logged_in(self, user):
    users = ', '.join(self.users - set([user]))
    self.send_command('say Other players online: %s' % users)

  def on_user_command(self, user, command, args):
    print user, command
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

if __name__ == '__main__':
  args = sys.argv[1:]
  secret = args[0]
  client = FancyClient()
  client.connect(secret)
  client.run_async()

  while True:
    command = raw_input('> ')
    client.send_command(command)