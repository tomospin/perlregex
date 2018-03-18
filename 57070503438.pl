# A simple program to move and change file path/name for a purpose
# Written by Sirapat Na Ranong 57070503438
# 18 March 2018
use File::Path qw(make_path);
use File::Copy;

$directory = '/cd-lib/mp3/playlists/*.m3u';
@files = glob($directory) or die "Directory not found\n";
closedir DIR;

foreach $file (@files) {
	if (-e $file) {
		print "Playlist: $file\n";
		open(DATA, $file) or die "ERROR while opening $file\n";
		@lines = <DATA>;
		close(DATA);
	} else {
		print "File $file doesn't exist\n";
		exit;
	}

	$path = @lines[0];
	$path =~ s/\n//;
	print "Song's old path: $path\n";
	$path =~ s/\/cd-lib\/mp3/music/;  # change /cd-lib/mp3 to music
	$path =~ s/[^\/]*\.mp3/files/;    # change 000-songname.mp3 to files (regex pattern = anything not / followed by .mp3)
	$path =~ s/_//;	# remove _ of subdirectory ex. Dixie_Chicken to DixieChicken
	print "Song's new path: $path\n";

	$playlistpath = $path;		
	$playlistpath =~ s/[^\/]*\/files//;  # ex. music/rock/LittleFeat/DixieChicken/files returns music/rock/LittleFeat/
	print "Playlist's new path: $playlistpath\n";
	$playlistname0 = $path =~ m/\/([^\/]*)\/files/;	# ex. music/rock/LittleFeat/DixieChicken/files returns DixieChicken
	$playlistname0 = $1;	
	$playlistname = $1 . "\.m3u"; # concatenate DixieChicken with .m3u
	print "Playlist's new name: $playlistname\n";

	if (!-d $path) {	      
		make_path($path) or die "Could not create new directory $path\n";
	} else {
		print "Directory $path exists\n";
	}

	open(DATA, '>' , $playlistpath . $playlistname) or die "Could not create $playlistname\n";

	foreach $line (@lines) {  # each line of song inside playlist
		$line =~ s/\n//;	# path of a song
		$songname = $line =~ m/[^\/]*\.mp3/;	# extract song name from path
		$songname = $&;	
		$songname =~ s/.mp3/.mpg/;
		if (-e $line) {
			print("Moving $line\n");
			move($line, $path . "\/" . $songname) or die "Copy failed\n";
		} else {
			print "File $line doesn't exist\n"
		}
		print DATA "./$playlistname0/files/$songname\n";
	}
	close(DATA);
}