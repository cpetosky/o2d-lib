from cypy import minecraft
import datetime
import optparse
import random
import tarfile
import thread
import time

class LocalClient(minecraft.AdminClient):
    """A client designed to be run from the same directory as the server.

    It provides low-level feature additions that would otherwise require
    modifying the server wrapper itself to do. Consequently, this extension
    will not work when run remotely, as it won't have access to the world
    data directly.
    """

    def __init__(self, backup_interval):
        self.last_backup = time.time()
        self.backup_interval = backup_interval
        self.running = True

    def on_logged_in(self, user):
        users = ', '.join(self.users - set([user]))
        self.send_command('say Other players online: %s' % users)

    def on_user_command_list(self, user, args):
        users = ', '.join(self.users)
        self.send_command('say Players online: %s' % users)

    def on_user_command_stuck(self, user, args):
        targets = list(self.users - set([user]))
        if len(targets) == 0:
            self.send_command(
                    "say Sorry, can't unstuck you if "
                    "you're the only one online.")
            return
        target = random.choice(targets)
        self.send_command('tp %s %s' % (user, target))
    
    def on_ready(self):
        thread.start_new(self._get_input, ())
        thread.start_new(self._backup_handler, ())
        self.backup()

    def _get_input(self):
        while self.running:
            command = raw_input('> ')
            client.send_command(command)

    def backup(self):
        now = datetime.datetime.now().isoformat()
        tar = tarfile.open('backups/world-backup-%s.tar.gz' % now, 'w:gz')
        tar.add('world')
        tar.close()
        self.last_backup = time.time()

    def _backup_handler(self):
        while self.running:
            time.sleep(self.backup_interval)

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
    parser.add_option(
            '-b', '--backup_interval', default=60*60*24,
            help='time in seconds between server backups (default 1 day)')
    options, args = parser.parse_args()
    client = LocalClient(backup_interval=options.backup_interval)
    client.connect(secret=options.secret, host=options.host, port=options.port)
