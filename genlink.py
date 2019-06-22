#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import sys


def getmeta(fullpath):
  info = {'fullpath': fullpath}
  with open(fullpath, 'r', encoding='utf-8') as f:
    for line in f:
      if line.startswith('#+TITLE:'):
        info['title'] = line.replace('#+TITLE:', '').strip()
      if line.startswith('#+DATE:'):
        info['date'] = line.replace('#+DATE:', '').strip()
    return info


def getinfos(dir):
  infos = []
  for root, dirs, files in os.walk(dir):
    for file in files:
      if file.endswith('.org'):
        fullpath = os.path.join(root, file)
        infos.append(getmeta(fullpath))
    return infos


def infos2text(infos):
  titles = []
  i = 1
  for e in infos:
    line = '{no:02d}. [[./{path}][{title}]] {date}'.format(
        no=i,
        path=e['fullpath'].replace('\\', '/'),
        title=e['title'],
        date=e['date']
    )
    i += 1
    titles.append(line)
  return '\n'.join(titles)


if __name__ == '__main__':
  content = '* Index'
  content += '\n** Articles\n'
  content += infos2text(getinfos('article'))
  content += '\n** Python\n'
  content += infos2text(getinfos('python'))
  content += '\n** Misc.\n'
  content += infos2text(getinfos('misc'))
  content += '\n'
  sys.stdout.buffer.write(content.encode("utf8"))
