<?php

$doc = new DOMDocument();
$doc->load( $argv[1] );

foreach( $doc->getElementsByTagName('referees') as $node )
{
	$comment = new DOMComment('Referees available upon request, thus filtered out.');
	$parent = $node->parentNode;
	$parent->insertBefore( $comment, $node );
	$parent->removeChild( $node );
}

$doc->save( $argv[2] );
