#!/usr/bin/env perl
# Version 1.0
# charlspjohn@gmail.com

use Term::ANSIColor;

# If there is an argument change directory to it
$dir = shift @ARGV;
if ($dir) {
	chdir $dir or die "Cannot chdir to \"$dir\": $!";
}

# Loading all file names to a list
@files = glob "*.mp4";

# Extracting movie names from actual file names
@base;
foreach $file (@files) {
	if ( $file =~ m/(^.*)_/ ) {
		push @base, $1;
	}
}

# Removing repeating items from a list of movie names
@final_list;
%seen;
foreach (@base) {
	if ( ! $seen{$_} ) {
		push @final_list, $_;
		$seen{$_} = 1;
	}
}

# Creating smil files
foreach $file (@final_list) {
$flag = undef;

$content = '<smil>
<head></head>
<body>
       <switch>' ."\n";

	foreach ( <"${file}*.mp4"> ) {
		if ( /_720p/ ) {
			$content .= '               <video src="mp4:' . $_ . '" system-bitrate="2270208" width="1280" height="720">
                       <param name="audioBitrate" value="196608" valuetype="data"/>
                       <param name="videoBitrate" value="2073600" valuetype="data"/>
                       <param name="videoCodecId" value="avc1.4d401f" valuetype="data"/>
                       <param name="audioCodecId" value="mp4a.40.2" valuetype="data"/>
               </video>' . "\n";
			$flag = 1;
			print color("green"), "OK: ", color("reset") . "Successfully processed \"$_\"\n";
		}
		elsif ( /_360p/ ) {
			$content .= '               <video src="mp4:' . $_ . '" system-bitrate="1046608" width="640" height="360">
                       <param name="audioBitrate" value="196608" valuetype="data"/>
                       <param name="videoBitrate" value="850000" valuetype="data"/>
                       <param name="videoCodecId" value="avc1.4d401f" valuetype="data"/>
                       <param name="audioCodecId" value="mp4a.40.2" valuetype="data"/>
               </video>' . "\n";
			$flag = 1;
			print color("green"), "OK: ", color("reset") . "Successfully processed \"$_\"\n";
		}
		elsif ( /_160p/ ) {
			$content .= '               <video src="mp4:' . $_ . '" system-bitrate="396608" width="284" height="160">
                       <param name="audioBitrate" value="196608" valuetype="data"/>
                       <param name="videoBitrate" value="200000" valuetype="data"/>
                       <param name="videoCodecId" value="avc1.428015" valuetype="data"/>
                       <param name="audioCodecId" value="mp4a.40.2" valuetype="data"/>
               </video>' . "\n";
			$flag = 1;
			print color("green"), "OK: ", color("reset") . "Successfully processed \"$_\"\n";
		}
		else {
			print STDERR color("red"), "Error: ", color("reset") . "\"$_\" is not in a supported resolution\n";
		}
	}

$content .= '       </switch>
</body>
</smil>' . "\n";

if ($flag) {
	open $FH, '>', "${file}.smil";
	print $FH "$content";
	close $FH;
}
}
