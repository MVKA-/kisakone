{*
 * Suomen Frisbeegolfliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm�
 *
 * RSS message for event news item
 *
 * --
 *
 * This file is part of Kisakone.
 * Kisakone is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Kisakone is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with Kisakone.  If not, see <http://www.gnu.org/licenses/>.
 * *}
 {capture assign=titleid}rss_{$item.type}{/capture}
{capture assign=textid}{$titleid}_text{/capture}
<title>{$item.title}</title>
<description>{$item.content}</description>
<pubDate>{$item.rssDate}</pubDate>
<link>http://{$smarty.server.HTTP_HOST}{$url_base}event/{$event->id}/signupinfo</link>
<guid>news_{$item.newsid}</guid>
