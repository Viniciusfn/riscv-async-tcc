
report power -verbose	    > ${REPORTS_PATH}${DESIGN}_power.rpt
report timing -lint   	    > ${REPORTS_PATH}${DESIGN}_time.rpt
report timing         	    > ${REPORTS_PATH}${DESIGN}_slack.rpt
report area           	    > ${REPORTS_PATH}${DESIGN}_area.rpt
report gates          	    > ${REPORTS_PATH}${DESIGN}_gates.rpt
report qor            	    > ${REPORTS_PATH}${DESIGN}_qor.rpt
report messages       	    > ${REPORTS_PATH}${DESIGN}_messages.rpt
report summary        	    > ${REPORTS_PATH}${DESIGN}_summary.rpt
report_multibit_inferencing > ${REPORTS_PATH}${DESIGN}_multibit.rpt
