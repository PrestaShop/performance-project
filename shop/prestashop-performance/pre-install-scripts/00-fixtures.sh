#!/bin/bash

        if [ "${PS_CUSTOM_FIXTURES_FOLDER}" != "" ]
        then
		echo ""
                echo " => Pushing custom fixtures from ${PS_CUSTOM_FIXTURES_FOLDER}..."
                rm -rf /var/www/html/install/fixtures/fashion/
                mkdir -p  /var/www/html/install/fixtures/fashion/
                cp -R /opt/"${PS_CUSTOM_FIXTURES_FOLDER}"/* /var/www/html/install/fixtures/fashion/
                sed -i -e 's/dni=""/dni="11111111"/g' /var/www/html/install/fixtures/fashion/data/address.xml
        else
		echo ""
                echo " => No Fixture variable found..."
        fi
