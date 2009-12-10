if { [info exists _CONENNECTCITY.TCL] == 0 } {
	set _CONENNECTCITY.TCL 1


if { [info exists env(HOST)] == 1 } {
	set host $env(HOST)
} elseif { [info exists env(HOSTNAME)] == 1 } {
	set host $env(HOSTNAME)
} else {
	puts "host variable not defined"
	set host localhost
}


	if { [string compare $host space] == 0 } { 
		connect city
		puts "conected to city" 
	} elseif { [string compare $host city] == 0  } {
		connect city
		puts "conected to city" 
	} else {
		connect 127.0.0.1
		puts "conected to 127.0.0.1" 
	}

	
}
