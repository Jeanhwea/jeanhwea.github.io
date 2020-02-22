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
        info['date'] = time.strptime(str, '<%Y-%m-%d %a %H:%M:%S>')
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
  res = '\n* ' + title + '\n'
  res += '\n'.join(items)
  return res


if __name__ == '__main__':
  # content = '* 目录'
  content = readdir('技术文章', 'article', by='date')
  content += readdir('编程语言', 'lang', by='name')
  content += readdir('开发工具', 'tool', by='name')
  content += readdir('数据库', 'database', by='name')
  content += readdir('杂文随笔', 'misc', by='date')
  content += '\n'
  sys.stdout.buffer.write(content.encode("utf8").lstrip())
