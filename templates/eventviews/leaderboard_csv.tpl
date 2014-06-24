{**
 * Suomen Frisbeegolfliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm�
 * Copyright 2013 Tuomo Tanskanen <tuomo@tanskanen.org>
 *
 * Leaderboard
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
 {if $mode == "head"}

<style type="text/css">{literal}
    .resultrow td, .resultrow th {
        border-right: 1px solid black;
        border-bottom: 1px solid black;
        text-align: center;

        margin: 0;
    }

    .results td, .results th {
        background-color: #EEE;
        text-align: center;
        border: 2px solid white;
    }

    .round_selection_table .selected {
        background-color: #DDD;

    }

    .results {
        border-collapse: collapse;
    }

    .rightside {
        text-align: right !important;
    }
    .leftside {
        text-align: left !important;
    }

    .thr {

    }
    .sdtd { background-color: white !important}

    .sd {
        background-color: #EEE !important;
        font-weight: bold;
        min-width: 16px;


    }

{/literal}</style>
{else}
 <div id="event_content">
    {$page->formattedText}
</div>


{assign var=extrahead value=$xtrahead}
<p class="preliminary" style="display: none">
    {translate id=preliminary_results}
</p>

<p>{translate id=leaderboard_cvs_help}</p>
<p>{translate id=leaderboard_cvs_help2}</p>

<textarea cols=120 rows=140>
{counter assign=rowind start=-1}{foreach from=$resultsByClass key=class item=results}
{foreach from=$results item=result}{counter assign=rowind}{if $rowind == 0}
{translate id=result_division}{""|indent:1:"\t"}{translate id=result_place}{""|indent:1:"\t"}{translate id=result_firstname}{""|indent:1:"\t"}{translate id=result_lastname}{""|indent:1:"\t"}PDGA{""|indent:1:"\t"}{foreach from=$rounds key=index item=round}{math assign=roundNumber equation="x+1" x=$index}{translate id=round_number_short number=$roundNumber}{""|indent:1:"\t"}{/foreach}{if $includePoints}{""|indent:1:"\t"}{translate id=result_tournament}{/if}{/if}

{$class|truncate:3:""}{""|indent:1:"\t"}{$result.Standing}{""|indent:1:"\t"}{$result.FirstName|escape}{""|indent:1:"\t"}{$result.LastName|escape}{""|indent:1:"\t"}{$result.PDGANumber|escape}{""|indent:1:"\t"}{foreach from=$rounds item=round key=index}{assign var=roundid value=$round->id}{assign var=rresult value=$result.Results.$roundid.Total}{assign var=roundresult value=$rresult}{if !$rresult}{assign var=roundresult value=""}{/if}{$roundresult}{""|indent:1:"\t"}{/foreach}{if $includePoints}{assign var=tournamentPoints value=$result.TournamentPoints}{if !$tournamentPoints}{assign var=tournamentPoints value=0}{/if}{math equation="x/10" x=$tournamentPoints}{""|indent:1:"\t"}{/if}
{/foreach}
{/foreach}
{/if}
</textarea>

