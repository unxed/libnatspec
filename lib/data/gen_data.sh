#!/bin/sh
# charset relation generator
#    $Id: gen_data.sh,v 1.8 2005/03/09 20:07:30 lav Exp $

OUTFILE=get_charset_data.h

print()
{
	printf " { \"%s\",\t%d,\t\"%s\",\t\"%s\",\t\"%s\",\t\"%s\" }%s\n" $@ >>$OUTFILE
}

echo Test string for $LANG locale:
./print_data_string || exit 1
echo
cat <<EOF >$OUTFILE
/* Do not edit this file!
   It is autogenerated from WINE program print_data_string.c
*/
static const struct charsetrel_entry charset_relation[] =
{
	/* locale,     lcid,    unix,        windows,    dos,      mac charset */
EOF
echo "Generating with WINE program..."
echo "This is log error file. See for your problem locale here and send me a mail: lav@etersoft.ru">./gen_data.out.txt
for i in `locale -a | LC_ALL=C sort`
do
#	printf "\t{ %-15s %d,\t\"%s\",\t\"%s\",\t\"%s\",\t\"%s\" }" "\"$i\"," `LANG=$i ./print_data_string 2>/dev/null` >>$OUTFILE
	echo -e -n " {" >>$OUTFILE
	LANG=$i LC_CTYPE=$i ./print_data_string 2>>./gen_data.out.txt >>$OUTFILE
	echo -e " }," >>$OUTFILE
done
echo >>$OUTFILE
echo "/* Follow entries is dummy for ASCII/ANSI encoding */" >>$OUTFILE
print "POSIX" 1033 ASCII CP1252 IBM437 "MAC" ,
print "POSIX" 1033 ANSIX341968 CP1252 IBM437 "MAC"
cat <<EOF >>$OUTFILE

};
EOF
