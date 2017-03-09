module ExternalResourcesGenesHelper


  def PrintWrapperPmid(id = '', data = nil)

  		# "<div class=\"WrapperPmid\" >"
  		# "<div class=\"form-group\">"
  		# "<div class=\"WrapperPmidResults\">"
  	varInner = ""
  	if !data.nil?
  	varStart = "<div class=\"GeneticEvidencePmidData\">"
  			data["publications"].each do |pubs|
  				varInner = pubs["author"] +" et al. "+ pubs["pubdate"] +" (PMID:"+ pubs["uid"] +"); "
  			end
  	varEnd = "</div>"

  	varStart + varInner + varEnd
  	else
  		""
  	end
  end
# 	function PrintWrapperPmid($id, $data = "") {
	
	
# 	if($data) {
		
# 		$var  = "<div class=\"WrapperPmid\" id=\"". $id ."\">";
# 		$var .= "<div class=\"form-group\">";
# 		$var .= "<div id=\"". $id ."PmidWrapper\" class=\"WrapperPmidResults\">";
		
# 			$publications = $data["0"]["group1"]["publications"];
# 		  $var .= "<div data-pmidInput='". $WrapperPmid ."' class='GeneticEvidencePmidData'>";
# 			foreach($publications as $key => $pubData){
				
# 				$wrapperUUID 		= $key;
# 				$WrapperPmid 		= $id;
# 				$wrapperUUIDGroup 	= "group1";
# 				$author				= $pubData["author"];
# 				$pubdate			= $pubData["pubdate"];
# 				$source				= $pubData["source"];
# 				$uid				= $pubData["uid"];
# 				$title				= $pubData["title"];
#         $note 					= $data["0"]["group1"]["notes"]["note"];
#         if($note) {
#           $note = "(". $note .")";
#         }
				
# 				// Remove the ext after the year
#         $pubdate = explode(" ", $pubdate);
        
# 				$var .= "". $author ." et al. ". $pubdate[0] ." (PMID:". $uid ."); ";
				
# 			}
# 				$var .= "". $note ."</div>";
		

		
# 		return $var;
		
# 	}
# }

end
