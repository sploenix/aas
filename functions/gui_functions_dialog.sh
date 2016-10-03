_temp="/tmp/answer.$$"

checkListWindow() {
	TYPE="--checklist"
	listWindow
}

radioListWindow() {
	TYPE="--radiolist"
	listWindow
}

listWindow() {
	echo "Opening checkListWindow"

  listTranslator

	# handle custom window size
	#customDim

	# open checklist dialog
	dialog $TYPE \
		"$TEXT_MSG" 15 50 $NEWCOUNT \
		"${NEWLIST[@]}" 2> $_temp

	# get exit code from gui
	EXITCODE=$?

  echo $EXITCODE
  echo `cat $_temp`

  kill -s TERM $TOP_PID

	# clean GUI data
	cleanGuiData

	# next action based on gui data
	exitCodeHandler
}

listTranslator() {
  echo ${LIST_ELEMENTS[@]}
#  LENGTH=${#LIST_ELEMENTS[@]}
#  echo $LENGTH
#  echo `seq 1 $LENGTH`
#  echo ${LIST_ELEMENTS[0]} ${LIST_ELEMENTS[7]}
  COUNTER=${#LIST_ELEMENTS[@]}
  NEWCOUNT=1
  until [ $COUNTER -lt 0 ]; do
    let COUNTER-=1
    ELEMENT=${LIST_ELEMENTS[$COUNTER]}
    let COUNTER-=1
    VALUE=${LIST_ELEMENTS[$COUNTER]}
    if [ "$VALUE" == "TRUE" ]; then
      VALUE="on"
    else
      VALUE="off"
    fi
    NEWLIST+=("$NEWCOUNT" "$ELEMENT" "$VALUE")
    let NEWCOUNT+=1
  done
}
