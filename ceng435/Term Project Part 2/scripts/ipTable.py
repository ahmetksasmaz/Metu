# We prepared a dictionary that includes
# "X_Y" : ('IPAddr',Port)
# Where X_Y means, X listens Y

# This IP Table is used for generalizing
# making socket connections
# and making easier to understand

ip_table = {
#s listens r* router (* is 1,2 or 3)
"s_r1" : ('10.10.1.1',14501),
"s_r2" : ('10.10.2.2',14502),
"s_r3" : ('10.10.3.1',14503),

#r* listens s router (* is 1,2 or 3)
"r1_s" : ('10.10.1.2',14510),
"r2_s" : ('10.10.2.1',14520),
"r3_s" : ('10.10.3.2',14530),

#d listens r* router (* is 1,2 or 3)
"d_r1" : ('10.10.4.2',14541),
"d_r2" : ('10.10.5.2',14542),
"d_r3" : ('10.10.7.1',14543),

#r* listens d router (* is 1,2 or 3)
"r1_d" : ('10.10.4.1',14514),
"r2_d" : ('10.10.5.1',14524),
"r3_d" : ('10.10.7.2',14534)
}
