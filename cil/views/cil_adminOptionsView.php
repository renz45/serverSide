<?php
add_action('show_admin_options_menu', 'show_options_menu');

function show_options_menu()
{
	echo '<div class="wrap">';
	echo '<p>Here is where the form would go if I actually had options.</p> <a id="test">TEST</a>';
	echo '</div>';
}

