<?php
/**
 * Suomen Frisbeeliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm�
 *
 * Stand-alone login form backend
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
 * */
/**
 * Initializes the variables and other data necessary for showing the matching template
 * @param Smarty $smarty Reference to the smarty object being initialized
 * @param Error $error If input processor encountered a minor error, it will be present here
 */
function InitializeSmartyVariables(&$smarty, $error)
{
    global $user;
    if ($user) {
        header("Location: " . baseurl());
    }
    if ($error) {
        $smarty->assign('failedAlready', true);
        $smarty->assign('errorMessage', $error->description);
    }
}

/**
 * Determines which main menu option this page falls under.
 *
 * This function is required by the interface, alhtough this page doesn't have
 * the menu.
 * @return String token of the main menu item text.
 */
function getMainMenuSelection()
{
    return 'index';
}
