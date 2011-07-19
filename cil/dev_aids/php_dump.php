<?php


/**
 * I couldn't find a friends version of cfDump so this is a quick and easy version to view contents of arrays and objects within php in a nice formated way.
 *
 * @param anything $value item to echo out, if it is an array or an object it will be formated in a nice way.
 */
function php_dump($value, $label=null)
{


	$return = "<script type='text/javascript' src='https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js'></script>
				<script type='text/javascript'>
					jQuery(document).ready(function() {

						jQuery('table.phpdump th').unbind().bind('click', function(){

							var children = jQuery(this).parent().parent().parent().find('>tbody').find('>tr>td');
							if(children.is(':visible'))
							{
								children.hide();
							}else{
								children.show();
							}
						});

					});
				</script>

				<style type='text/css'>
							table.phpdump {
							border-width: 1px;
							border-spacing: 2px;
							border-style: solid;
							border-collapse: collapse;
							}

							table.phpdump th {
								border-width: 1px;
								padding: 5px;
								border-spacing: 2px;
								border-style: solid;
								border-collapse: collapse;
							}

							table.phpdump th:hover {
								cursor:pointer;
							}

							td table.phpdump {
								margin: 0;
							}

							table.phpdump td {
								border-width: 1px;
								padding: 5px;
								border-style: inset;
								display:none;
							}


							.php_dump_legend {
								width = 5px;
								padding: 3px;
								display: inline;
								margin-right: 5px;
							}

							#php_dump_legend_container {
								padding:5px;
							}

							/* array styles */
							table.phpdump.php_dump_array,
							table.phpdump.php_dump_array>tbody>tr>td:first-child,
							table.phpdump.php_dump_array>thead th,
							.php_dump_array  {
								background-color: rgb(255, 221, 221);
								color: #a00;
								border-color: #a00;
							}

							.php_dump_array {
								border: 1px solid #a00;
								padding: 5px;
							}

							table.phpdump.php_dump_array>thead th {
								background-color: #fee;
								color: #a00;
							}
							table.phpdump.php_dump_array>thead th:hover {
								background-color: #faa;
							}

							/* Object styles */
							table.phpdump.php_dump_object,
							table.phpdump.php_dump_object>tbody>tr>td:first-child,
							table.phpdump.php_dump_object>thead th,
							.php_dump_object  {
								background-color: #ebd09e;
								color: #a06602;
								border-color: #a06602;
							}

							.php_dump_object {
								border: 1px solid #a06602;
								padding: 5px;
							}

							table.phpdump.php_dump_object>thead th {
								background-color: #fce0af;
								color: #a06602;
							}
							table.phpdump.php_dump_object>thead th:hover {
								background-color: #ffc869;
							}

							/* String styles */
							table.phpdump td.php_dump_string, .php_dump_string {
								background-color: #afa;
								color: #080;
								border: 1px solid #080;
								padding:5px
							}

							/* int styles */
							table.phpdump td.php_dump_int, .php_dump_int {
								background-color: #ccf;
								color: #008;
								border: 1px solid #008;
								padding:5px
							}

							/* float styles */
							table.phpdump td.php_dump_float, .php_dump_float {
								background-color: #fcf;
								color: #808;
								border: 1px solid #808;
								padding:5px
							}

							/* boolean styles */
							table.phpdump td.php_dump_bool, .php_dump_bool {
								background-color: #ffa;
								color: #880;
								border: 1px solid #880;
								padding:5px
							}

							/* null styles */
							table.phpdump td.php_dump_null, .php_dump_null {
								background-color: #333;
								color: #eee;
								border: 1px solid #eee;
								padding:5px
							}

							</style>

							<div id='php_dump_legend_container'>\n";
	if(!is_null($label))
	{
		$return .= "<span>$label &nbsp;&darr;&nbsp;</span>\n";
	}
	$return .= 					"<div class='php_dump_string php_dump_legend'>String</div>
	    						<div class='php_dump_int php_dump_legend'>Int</div>
	    						<div class='php_dump_float php_dump_legend'>Float</div>
	    						<div class='php_dump_bool php_dump_legend'>Boolean</div>
	    						<div class='php_dump_array php_dump_legend'>Array</div>
	    						<div class='php_dump_object php_dump_legend'>Object</div>
							</div>\n";



	$parser = new phpDumpParser();

	if(is_array($value))
	{
		$return .= $parser->parseArray($value);
	}else if(is_object($value))
	{
		$return .= $parser->parseObject($value);
	}else if(is_string($value))
	{
		$return .= "<p class='php_dump_string'>". htmlentities($value) ."</p>";
	}else if(is_int($value))
	{
		$return .= "<p class='php_dump_int'>$value</p>";
	}else if(is_float($value))
	{
		$return .= "<p class='php_dump_float'>$value</p>";
	}else if(is_bool($value))
	{
		if($value == false)
		{
			$return .= "<p class='php_dump_bool'>False : Boolean</p>";
		}else{
			$return .= "<p class='php_dump_bool'>True : Boolean</p>";
		}
	}else if(is_null($value))
	{
		$return .= "<p class='php_dump_null'>Value is NULL</p>";
	}

	echo $return;
}

//class with parsing methods
class phpDumpParser
{
    public function __construct()
    {

    }

    public function parseArray($arr)
    {

    	$result = "<table class='phpdump php_dump_array'>
    				<thead><th colspan=2>Array : length = ". count($arr) ."</th></thead>
    				<tbody>\n";

		$result .= $this->fillTable($arr);

		$result .= "</tbody></table>\n";
		return $result;
    }

    //parse object
 public function parseObject($obj)
    {

    	$result = "<table class='phpdump php_dump_object'>
    				<thead><th colspan=2>Object</th></thead>
    				<tbody>\n";

		$result .= $this->fillTable($obj);

		$result .= "</tbody></table>\n";
		return $result;
    }

    //fills in the table for objects and arrays
    private function fillTable($item)
    {
		$result = "";

   		foreach($item as $key => $value)
		{
			$result .= "<tr>";
			$result .= "<td>" . $key . "</td>";
			if(is_array($value))//if array
			{
				$result .= "<td>" . $this->parseArray($value) . "</td>";
			}else if(is_object($value))//if object
			{
				$result .= "<td>" . $this->parseObject($value) . "</td>";
			}else if(is_string($value))//if string
			{
				$result .= "<td class='php_dump_string'>" . htmlentities($value) . "</td>";
			}else if(is_int($value))//if int
			{
				$result .= "<td class='php_dump_int'>" . $value . "</td>";
			}else if(is_float($value)) // if float
			{
				$result .= "<td class='php_dump_float'>" . $value . "</td>";
			}else if(is_bool($value))// if bool
			{
				if($value == false)//php converts the boolean to a 1 or 0, this just translates is back to 'true' or 'false'
				{
					$result .= "<td class='php_dump_bool'>False : Boolean</td>";
				}else{
					$result .= "<td class='php_dump_bool'>True : Boolean</td>";
				}
			}
			$result .= "</tr>\n";
		}

		return $result;
    }
}