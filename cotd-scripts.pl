sub crap()
{
  $error = "$_ . \n";
  open(LOG, '+>', $logfile) or  die("Meta-error!!!: \n$error Can't open logfile: $!");
  print LOG $error;
  close(LOG);
  exit(666);
}
