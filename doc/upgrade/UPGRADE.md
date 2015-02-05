Upgrading
=========

If you installed your Kisakone via `git clone` and not from a tarball, you are in for a treat!

Always:
 - Take backups from your database!
 - `git fetch` to update sources in index
 - `git checkout <release number>`

Then, FOR EACH RELEASE IN BETWEEN YOUR CURRENT VERSION AND THE ONE YOU WANT:
 - Follow instructions in `doc/upgrade/upgrade_to_<release number>.md`
 - Document tells you what we need to do to upgrade to next version. If document is missing, nothing to be done, move on.
 - Typically, you need to fix your site config at `config_site.php`
 - Run upgrade script at `doc/upgrade/<release number>`, ie. `php upgrade.php`. No output GOOD.
 - Repeat until you've caught up!