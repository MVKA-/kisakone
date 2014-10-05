{**
 * Suomen Frisbeegolfliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhmä
 * Copyright 2014 Tuomo Tanskanen <tuomo@tanskanen.org>
 *
 * Tournament editor ui backend
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
 {assign var=title value=$event->name}
 {capture assign=extrahead}
 <style type="text/css">{literal}
    .resultrow td, .resultrow th {

        text-align: center;
        border: 2px solid white;
        margin: 0;
    }

    .results td, .results th {
        background-color: #EEE;
        text-align: center;

    }

    .results {
        border-collapse: collapse;
    }

    input[type="text"] {
        border: 1px solid #BBB;
    }


    .e_err {
        background-color: red;
    }

    .e_pm0 {
        background-color: #EEE !important;
    }

    .e_m1 {
        background-color: #f6a690 !important;
    }

    .e_mm {
        background-color: #f6a690 !important;
    }

    .e_p1 {
        background-color: #aacfcf !important;



    }
    .e_p2 {
        background-color: #51787e !important;
        color: white;

    }

    .e_pm {
       background-color: #51787e !important;
        color: white;

    }

    .results input {
        text-align: center;
    }

    .name_hilight {
        background-color: #AFA !important;
    }

    #result_table input {
        width: 95% !important;
        margin: 2px;
    }

    .spacing td { background-color: #F8F8F8 !important;}

{/literal}</style>
{/capture}
{include file='include/header.tpl' ui=true}

{include file=support/eventlockhelper.tpl}

<div class="nojs">
{translate id=page_requires_javascript}
</div>

<div class="jsonly">



<p><button id="toggle_submenu">{translate id=toggle_menu}</button></p>

<div class="searcharea">
    <p>
        <form id="searchForm">
        <span>{translate id=inline_search_help}</span> <input style="border: 1px solid black" type="text" id="searchField" />
        <input type="submit" id="searchButton" disabled="disabled" value="{translate id=button_goto}" />
        <span id="x_results_found">{translate id="search_results"} </span><span id="x_results">0</span>
        </form>
    </p>
    <p>{translate id="result_search_extrahelp"}</p>

</div>

<table class="results" id="result_table">
    {foreach from=$results item=group key=groupind}
        {if $groupind % 3 == 1}
            <tr>
               <td style="height: 8px; background-color: white;"></td>
            </tr>
            <tr class="thr">
                <th>{translate id=result_group}</th>
                <th>{translate id=result_name}</th>
                <th>{translate id=result_pdga}</th>
                <th>{translate id=hole_num} <br />{translate id=hole_par}</th>
                {foreach from=$holes key=index item=hole}
                    <th>

                        {$hole->holeNumber}<br />{$hole->par}
                        </th>
                {/foreach}
                <th>{translate id=result_penalty}</th>
                <th>{translate id=result_suddendeath}</th>
                <th>{translate id=result_total}</th>
                <th>+/-</th>
                <th>{translate id=event_save}</th>
            </tr>
            <tr>
               <td style="height: 8px; background-color: white;"></td>
            </tr>
        {/if}

        {foreach from=$group item=result key=memberInd}
            <tr class="resultrow player_{$result.playerId}">
                <td>{$result.PoolNumber}</td>
                <td>{$result.FirstName|escape} {$result.LastName|escape}</td>
                <td>{$result.PDGANumber}</td>
                <td></td>
                {foreach from=$holes item=hole key=hindex}
                    {assign var=holenum value=$hole->holeNumber}
                    <td class="{if $hindex % 2 == 1}c1{else}c0{/if}">
                        {assign var=holeresult value=$result.Results.$holenum.Result}

                        <input type="text" id="r{$result.PlayerId}_{$hole->id}" size="2" name="r{$result.PlayerId}_{$hole->id    }" value="{$holeresult}" />

                    </td>
                {/foreach}
                <td>
                    <input class="penalty" type="text" id="r{$result.PlayerId}_p" size="2" name="r{$result.PlayerId}_p" value="{$result.Penalty}" /></td>
                <td>
                    <input type="text" id="r{$result.PlayerId}_sd" size="2" name="r{$result.PlayerId}_sd" value="{$result.SuddenDeath}" /></td>
                <td class="total" id="r{$result.PlayerId}_t">{$result.Total}</td>
                <td class="c0 plusminus" id="r{$result.PlayerId}_pm">{$result.TotalPlusMinus}</td>
                <td id="r_{$result.PlayerId}_sv">{translate id=all_ready}</td>

            </tr>
        {/foreach}
        <tr class="spacing">
            <td colspan="3">&nbsp;</td>
            {foreach from=$holes item=par key=hole}<td></td>{/foreach}
            <td colspan="5" class="lastsaved"></td>
        </tr>
    {/foreach}

</table>


    <script type="text/javascript" src="{url page=javascript/live}"></script>
    <script type="text/javascript">
    //<![CDATA[
    var holes = new Array();
    {foreach from=$holes item=hole}
        holes[{$hole->holeNumber}] = {$hole->par};
    {/foreach}
    holes["p"] = 0;
    var eventid = {$eventid};
    var roundid = {$roundid};


    var all_ready = "{translate id=all_ready}";
    var unsaved = new Array();
    {literal}



    $(document).ready(function(){
        //initializeLiveUpdate(3, eventid, updateField, updateBatchDone);
        liveChangeCallback = updateField;
        liveDoneCallback = updateBatchDone;

        $("#result_table input").focus(inputFocus);
        $("#result_table input").blur(inputBlur);
        $("#result_table input").keyup(change);
        $("#result_table input").change(change);
        $("#result_table input").keydown(keydown);

        $("#searchField").keyup(searchUpdate);
        $("#searchField input").change(searchUpdate);
        $("#searchForm").submit(searchGoto);

        scheduleLiveUpdate = function() {};

        $("#toggle_submenu").click(toggleSubmenu);

        AutoSave();
    });


    var doingAuto = false;
    var lastSaved = 0;
    function AutoSave() {
        setTimeout(AutoSave, 3000);

        if (focused) {
            if (valueOnEntry == focused.value) return;
        } else {
            return;
        }

        lastSaved++;
        if (lastSaved >= 3) {
            lastSaved = 0;
            try {
                if (focused) {
                    var focusNow = focused;
                    $(focusNow).blur();
                    doingAuto = true;
                    $(focusNow).focus();
                    doingAuto = false;
                }
            }
            catch (e) {

            }
        }

    }

    // Accepts numbers, characters go to search box
    function keydown(e) {
        if (!e) e = window.event;


        if (e.keyCode == 13) {

            var next = findNextInput1(this);
            next.focus();
        } else if (e.keyCode >= 48 && e.keyCode <= 57) { // 0..9
            return true;
        } else if (e.keyCode >= 65 && e.keyCode <= 90)  {
            initSearch(String.fromCharCode(e.keyCode));
        } else if (e.keyCode == 192) {
            initSearch('Ö');
        }
        else if (e.keyCode == 222) {
            initSearch('Ä');
        }
        else if (e.keyCode == 192) {
            initSearch('Å');
        } else {
            return true;
        }
        e.preventDefault();
        return false;
    }

    function initSearch(initialText) {
        $("#searchField").get(0).value = initialText;
        $("#searchField").get(0).focus();

        searchUpdate();
    }

    var singleFoundRow = null;

    // Searches for the correct row
    function searchUpdate() {
        var text = $("#searchField").get(0).value;
        var results = 0;

        var words = text.split(' ');
        if (text != "") {
            var row = $("#result_table tr").get(0);
            while (row) {
                if (row.tagName && row.tagName.match(/TR/i)) {
                    var tds = $(row).find("td");
                    var fine = true;
                    for (var i = 0; i < words.length; ++i) {
                        var word = words[i];

                        // Try match PDGA numbers
                        if (word.match(/\d+/)) {
                            var pdgatd = tds.get(2);
                            if (!pdgatd) {
                                fine = false;
                                break;
                            }

                            var pdga = pdgatd.textContent || pdgatd.innerText;
                            if (!pdga) {
                                fine = false;
                                break;
                            }

                            if (!pdga.match(new RegExp(word, "i"))) {
                                fine = false;
                                break;
                            }
                        }
                        // Try match names
                        else {
                            var nametd = tds.get(1);
                            if (!nametd) {
                                fine = false;
                                break;
                            }

                            var name = nametd.textContent || nametd.innerText;
                            if (!name) {
                                fine = false;
                                break;
                            }

                            if (!name.match(new RegExp(word, "i"))) {
                                fine = false;
                                break;
                            }
                        }
                    }

                    if (fine) {
                        results++;
                        singleFoundRow = row;
                    }
                }

                row = row.nextSibling;
            }
        }
        $("#x_results").empty();
        $("#x_results").get(0).appendChild(document.createTextNode(results));

        $("#searchButton").get(0).disabled = results != 1;
    }


    var hilightedName = null;
    function searchGoto(e) {
        if (!e) e=  window.event;

        e.preventDefault();

        if (hilightedName) $(hilightedName).removeClass('name_hilight');

        hilightedName = $(singleFoundRow).find("td").get(1);

        $(hilightedName).addClass('name_hilight');

        $(singleFoundRow).find("td input").get(0).focus();
        return false;
    }

    // Attempts to find an input following the input we have now
    function findNextInput1(from) {
        if (!from) return null;

        var next = from.nextSibling;
        while (next) {
            //alert(next.tagName);
            var potential = findNextInput2(next);
            if (potential) {
                return potential;
            }

            next = next.nextSibling;
        }
        return findNextInput1(from.parentNode);
    }

    function findNextInput2(item) {
        //alert(item.tagName);
        if (!item.tagName) return null;
        if (item.tagName && item.tagName.match(/^input$/i)) {
            return item;
        }

        for( var i = 0; i < item.childNodes.length ; ++i) {

            var potential = findNextInput2(item.childNodes[i]);

            if (potential) {
                return potential;
            }
        }

        return null;
    }

    function toggleSubmenu() {
        $("#submenucontainer").toggle();
    }





    var anyChanges = false;


    var fh1, fh2, fh3;
    var valueOnEntry;
    var focused;

    function inputFocus() {
        focused = this;
        if (!doingAuto) this.select();

        fh1 = this.parentNode.parentNode.firstChild;

        while (!fh1.tagName || !fh1.tagName.match(/^td$/i)) {
            fh1 = fh1.nextSibling;


        }

        var col = getColumnOf(this.parentNode);

        var pp = this.parentNode.parentNode;
        while (pp != null && !isHeadingRow(pp)) {
            pp = pp.previousSibling;
        }

        if (pp) fh2 = $(pp).find("th:eq(" + col + ")").get(0);

        pp = this.parentNode.parentNode;
        while (pp != null && !isHeadingRow(pp)) {
            pp = pp.nextSibling;
        }
        if (pp) fh3 = $(pp).find("th:eq(" + col + ")").get(0);

        $(fh1).addClass("focused");
        $(fh2).addClass("focused");
        $(fh3).addClass("focused");
        $(this.parentNode).addClass("focused");
        valueOnEntry = this.value;
    }

    function isHeadingRow(r) {
        var c = r.firstChild;
        while (c != null) {
            if (c.tagName) {
                if (c.tagName.match(/^td$/i)) return false;
                if (c.tagName.match(/^th$/i)) return true;
            }

            c = c.nextSibling;
        }
        return false;
    }

    function inputBlur() {
        lastSaved = 0;
        focused = null;
        $(fh1).removeClass("focused");
        $(fh2).removeClass("focused");
        $(fh3).removeClass("focused");
        $(this.parentNode).removeClass("focused");

        if (this.value != valueOnEntry) {
            var v = this.value;
            if (v == "") v = "0";
            if (v == "0"  || parseInt(v)) {
                if (parseInt(v) < 0) return;
                UpdateSaveStatus(GetPlayerId(this.name), +1);
                jQuery.ajax({
                    cache: false,
                    data: {id: eventid, lastUpdate: lastUpdate, field: this.name, value: this.value, action: 'enterresult', round: roundid},
                    dataType: 'json',
                    error: saveError,
                    success: saved,
                    url: "{/literal}{url page=liveresultdata}{literal}"


	});
            }
        }
        }

        var errorNotifications = 0;
        function saveError(xhr, errortext, errorthrown) {
            // Max 3 warnings
            if (errorNotifications == 3)
                return;
            errorNotifications++;

            alert({/literal}"{translate id=save_failed}"{literal});
        }

    function saved(data){
        var pid = parseInt(data.status);
        if (!pid) {
            alert(data.status);
        } else {
            UpdateSaveStatus(pid, -1);
        }

        handleLiveUpdateData(data);
    }

    function change() {
        var v = this.value;
        var classes = ["e_err", "e_pm0", "e_m1", "e_mm", "e_p1", "e_p2", "e_pm"];
        var p = $(this);
        for (var i = 0; i < classes.length; ++i) p.removeClass(classes[i]);
         if  (v == "" || v == "0") {
            UpdateTotals(this);
         }
        else if (!parseInt(v) || parseInt(v) < 0) {

            p.addClass("e_err");
        } else {
            var col = getHoleOf(this.parentNode);

            var par = holes[col + 1];
            var c = "";



            if (v == par) c = "e_pm0";
            else if (v == par + 1) c = "e_p1";
            else if (v == par + 2) c = "e_p2";
            else if (v > par) c = "e_pm";
            else if (v == par - 1) c = "e_m1";
            else if (v != 0) c = "e_mm";

            if (c != "") p.addClass(c);

            UpdateTotals(this);

        }
    }

    function GetPlayerId(fieldname) {
        return parseInt(fieldname.substring(1));
    }

    function UpdateSaveStatus(pid, adjustment) {
        if (!unsaved[pid]) {
            unsaved[pid] = adjustment;
        } else {
            unsaved[pid] += adjustment;
        }

        var num = unsaved[pid];
        var element = $("#r_" + pid + "_sv");
        if (num) {
            element.empty();
            element.get(0).appendChild(document.createTextNode(num));
        } else {
            element.empty();
            element.get(0).appendChild(document.createTextNode(all_ready));
        }
    }

    function UpdateTotals(srcinput) {
        var tr = $(srcinput).closest("tr");
        var inputs = tr.find("input");

        var total = 0;
        var plusminus = 0;
        var dns = false;

        for (var holenum in holes) {
            if (!parseInt(holenum)) continue;

            var input = inputs.get(holenum - 1);
            if (input.value != "" && input.value != "0") {
                var val = parseInt(input.value);
                total += val;
                plusminus +=  val - holes[holenum] ;
            } else if (input.value == "99" || input.value == "999") {
                dns = true;
                break;
            }
        }

        var penaltyInput = tr.find(".penalty").get(0);
        var penalty = parseInt(penaltyInput.value);
        if (!penalty) penalty = 0;

        total += penalty;
        plusminus += penalty;


        var totalElement = tr.find(".total").get(0);
        $(totalElement).empty();
        totalElement.appendChild(document.createTextNode(total));

        var pmElement = tr.find(".plusminus").get(0);
        $(pmElement).empty();
        pmElement.appendChild(document.createTextNode(plusminus));
    }

    function getHoleOf(td){
        var fe = td.parentNode.firstChild;
        var holeind = -5;
        while (fe != null) {
            if (fe.tagName && fe.tagName.match(/^td$/i)) {
                holeind++;
                if (fe == td) return holeind;
            }
            fe = fe.nextSibling;
        }
        return -1;
    }

    function updateField(data) {
        var fieldid = "r" + data.pid + "_" + data.hole;

        var field = document.getElementById(fieldid);



        if (field) {
            var current = parseInt(field.value);
            if (isNaN(current)) current = 0;
            var diff = data.value - current;


            if (diff) {

                var dontChangeValue = false;
                if (data.hole == "p" || data.hole == "sd") {
                    if (focused == field) dontChangeValue = true;
                }
                if (!dontChangeValue) field.value = data.value;

                $(field).effect("highlight", {color: '#5F5'}, 30000);

                var totfield = document.getElementById("r" + data.pid + "_t");
                var ctot = parseInt(totfield.innerText || totfield.textContent);
                if (isNaN(ctot)) ctot = 0;

                if (totfield.firstChild) totfield.removeChild(totfield.firstChild);
                totfield.appendChild(document.createTextNode(ctot + diff));
                $(totfield).effect("highlight", {color: '#55F'}, 30000);

                var pmfield = document.getElementById("r" + data.pid + "_pm");
                var cpm = parseInt(pmfield.innerText || pmfield.textContent);

                var par = holes[data.holeNum];

                if (data.hole != "sd") {
                    if (data.hole == "p") par = 0;

                    if (data.value == 0) {
                        newpm = cpm - (current - par);
                    } else if (current == 0) {
                        newpm = cpm + (data.value - par);
                    } else {
                        newpm = cpm + diff;
                    }
                    //alert(cpm + " " + newpm + " " + diff);

                    if (pmfield.firstChild) pmfield.removeChild(pmfield.firstChild);
                    pmfield.appendChild(document.createTextNode(newpm));
                    $(pmfield).effect("highlight", {color: '#55F'}, 30000);
                }
            }


        }
        anyChanges = true;
    }

    function updateBatchDone() {
        anyChanges = false;
    }


    {/literal}


    //]]>
    </script>
    <form method="post" action="{url page=event id=$smarty.get.id view=leaderboard}">
    <input type="submit" value="{translate id=button_ready}" />
    </form>




</div>


{include file='include/footer.tpl' noad=1}
