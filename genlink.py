#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os


class IndexManager(object):

  def __init__(self):
    self._readme = 'readme.org'

  def getmeta(self, fullpath):
    info = {'fullpath': fullpath}
    with open(fullpath, 'r', encoding='utf-8') as f:
      for line in f:
        if line.startswith('#+TITLE:'):
          info['title'] = line.replace('#+TITLE:', '').strip()
        if line.startswith('#+DATE:'):
          info['date'] = line.replace('#+DATE:', '').strip()
    return info

  def getinfos(self, dir):
    infos = []
    for root, dirs, files in os.walk(dir):
      for file in files:
        if file.endswith('.org'):
          fullpath = os.path.join(root, file)
          infos.append(self.getmeta(fullpath))
    return infos

  def infos2text(self, infos):
    titles = []
    i = 1
    for e in infos:
      line = '{i:02d}. [[./{path}][{title}]] {date}'.format(
          i=i, path=e['fullpath'], title=e['title'], date=e['date']
      )
      i += 1
      titles.append(line)
    return '\n'.join(titles)

  def readheader(self, EOH='# END OF HEADER'):
    header = ''
    with open(self._readme, 'r', encoding='utf-8') as f:
      for line in f:
        header += line
        if line.startswith(EOH):
          break
    return header

  def writereadme(self):
    content = self.readheader()
    content += '\n* Index'
    content += '\n** Articles\n'
    content += self.infos2text(self.getinfos('article'))
    content += '\n** Python\n'
    content += self.infos2text(self.getinfos('python'))
    content += '\n** Misc.\n'
    content += self.infos2text(self.getinfos('misc'))

    with open(self._readme, 'w', encoding='utf-8') as f:
      f.write(content)


if __name__ == '__main__':
  im = IndexManager()
  im.writereadme()
