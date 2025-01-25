#!/usr/bin/env python3

import subprocess as sp
import os
import shutil
import argparse

# Dotfile live on the root of a users $HOME path
location = os.path.expandvars('$HOME/.dotfiles')
location_backup = os.path.expandvars('$HOME/.dotfiles-backup')
worktree = os.path.expandvars('$HOME')

# Only used to obtain repo file listing
tmploc = '/tmp/dottest-listing'

gbareclone = ['git', 'clone', '--bare', 'https://github.com/kevclark/dotfiles.git',
              location]
gtmpclone = ['git', 'clone', 'https://github.com/kevclark/dotfiles.git', tmploc]
glist = ['git', '--git-dir=' + tmploc + '/.git', 'ls-files']


def dotfiles(gitcmd):
    """
    Run any git command as the working dotfile worktree
    """
    global location
    global worktree
    gitcli = ['git', '--git-dir=' + location, '--work-tree=' + worktree]
    gitcli.extend(gitcmd)

    try:
        sp.run(gitcli, check=True)
    except Exception as e:
        print('Git cli failed: {}'.format(e))


def ls_dotfiles(report=False):
    """
    Get dotfiles listing
    """
    global tmploc
    global gtmpclone
    global glist
    try:
        if os.path.exists(tmploc):
            # Delete temp clone if already exists
            print('\t{} already exists, removing...'.format(tmploc))
            shutil.rmtree(tmploc)

        sp.run(gtmpclone, stderr=sp.DEVNULL, check=True)
        files = sp.run(glist, check=True, stdout=sp.PIPE, stderr=sp.DEVNULL,
                       universal_newlines=True).stdout.split('\n')

        if(report):
            print('Dotfiles listing:\n')
            for f in files:
                print('\t{}'.format(f))

    except Exception as e:
        files = ''
        print('Failed to git dotfile listing: {}'.format(e))

    return files


def prepare_worktree():
    """
    Check for existing dotfiles, and move out the way if they already exist
    """
    try:
        files = ls_dotfiles()
        for f in files:
            if f:
                gitfile = worktree + '/' + f
                if os.path.isfile(gitfile):
                    print('\t{} already exists - moving to {}'.format(gitfile,
                          location_backup))
                    dirname = os.path.dirname(f)
                    if not os.path.exists(location_backup + '/' + dirname):
                        os.makedirs(location_backup + '/' + dirname)
                    shutil.move(gitfile, location_backup + '/' + f)

        # Move any worktree clone out of the way
        if os.path.exists(location):
            print('\t{} already exists - moving to {}'.format(location,
                  location_backup))
            backup_path = location_backup + '/' + os.path.basename(location)
            if os.path.exists(backup_path):
                print('\tRemoving old backup of {}'.format(location_backup
                      + '/' + location))
                shutil.rmtree(backup_path)
            shutil.move(location, location_backup + '/'
                        + os.path.basename(location))
    except Exception as e:
        print('Failed to prepare worktree: {}'.format(e))


def get_dotfiles():
    """
    Clone and checkout dotfiles
    """
    try:
        sp.run(gbareclone, stderr=sp.DEVNULL, check=True)
        dotfiles(['checkout'])
        dotfiles(['config', 'status.showUntrackedFiles', 'no'])
    except Exception as e:
        print('Failed to setup new dotfiles: {}'.format(e))


def further_config():
    """
    Apply any further config to user OS files
    """
    enabletitlebarcmd = ['gsettings', 'set', 'org.gnome.Terminal.Legacy.Settings', 'headerbar', 'false']
    setclassicbarcmd = ['gsettings', 'set', 'org.gnome.Terminal.Legacy.Settings', 'default-show-menubar', 'false']
    try:
        sp.run(enabletitlebarcmd , stderr=sp.DEVNULL, check=True)
        sp.run(setclassicbarcmd  , stderr=sp.DEVNULL, check=True)
    except Exception as e:
        print('Failed to apply further config: {}'.format(e))
        

# Main
if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--ls-files', action='store_true', help='List dotfiles'
                        + 'only')
    parser.add_argument('--testing', action='store_true', help='Make home to'
                        + 'current dir rather than $HOME')
    args = parser.parse_args()

    if args.testing:
        print('[Testing] Making dotfiles in current dir')
        location = './dottest'
        location_backup = './dotfiles-backup'
        worktree = '.'
        gbareclone = ['git', 'clone', '--bare',
                      'https://github.com/kevclark/dotfiles.git', location]

    if args.ls_files:
        ls_dotfiles(True)
    else:
        print('Preparing worktree area...')
        prepare_worktree()
        print('Get dotfiles...')
        get_dotfiles()
        further_config()
