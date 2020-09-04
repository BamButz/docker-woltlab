<?php

require_once('./global.php');

$cronjobAction = new \wcf\data\cronjob\CronjobAction(array(), 'executeCronjobs');
$cronjobAction->executeAction();

// Remove Session
wcf\system\WCF::getSession()->delete();