#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import sys
import time


def parsemeta(url):
  info = {'url': url}
  with open(url, 'r', encoding='utf-8') as f:
    for line in f:
      if line.startswith('#+TITLE:'):
        info['title'] = line.replace('#+TITLE:', '').strip()
      if line.startswith('#+DATE:'):
        str = line.replace('#+DATE:', '').strip()
        info['date'] = time.strptime(str, '<%Y-%m-%d %a>')
    return info


def getinfos(dir):
  infos = []
  for root, dirs, files in os.walk(dir):
    for file in files:
      if file.endswith('.org'):
        url = os.path.join(root, file)
        infos.append(parsemeta(url))
    return infos


def readdir(title, folder, by='name'):
  infos = getinfos(folder)
  if by == 'date':
    infos.sort(key=lambda x: -time.mktime(x['date']))
  elif by == 'name':
    infos.sort(key=lambda x: x['url'])
  items = []
  for index, info in enumerate(infos, start=1):
    items.append('{index:02d}. [[./{path}][{title}]] {date}'.format(
        index=index,
        path=info['url'].replace('\\', '/'),
        title=info['title'],
        date=time.strftime('%Y-%m-%d', info['date'])
    ))
  res = '\n** ' + title + '\n'
  res += '\n'.join(items)
  return res


if __name__ == '__main__':
  content = '* Index'
  content += readdir('Articles', 'article', by='date')
  content += readdir('Programming Language', 'lang')
  content += readdir('Misc.', 'misc')
  content += '\n'
  sys.stdout.buffer.write(content.encode("utf8"))
