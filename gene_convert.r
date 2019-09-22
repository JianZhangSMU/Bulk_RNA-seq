
# # Basic function to convert mouse to human gene names
# convertMouseGeneList <- function(x){
#   require("biomaRt")
#   human = useMart("ensembl", dataset = "hsapiens_gene_ensembl")
#   mouse = useMart("ensembl", dataset = "mmusculus_gene_ensembl")
#   genesV2 = getLDS(attributes = c("mgi_symbol"), filters = "mgi_symbol", values = x , mart = mouse, attributesL = c("hgnc_symbol"), martL = human, uniqueRows=T)
#   humanx <- unique(genesV2[, 2])
#   # Print the first 6 genes found to the screen
#   print(head(humanx))
#   return(humanx)
# }

# Basic function to convert human to mouse gene names
convertHumanGeneList <- function(x){
  require("biomaRt")
  human <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")
  mouse <- useMart("ensembl", dataset = "mmusculus_gene_ensembl")
  
  genesV2 <- getLDS(attributes = c("hgnc_symbol"),
                    filters = "hgnc_symbol",
                    values = x,
                    mart = human,
                    attributesL = c("mgi_symbol"),
                    martL = mouse,
                    uniqueRows=TRUE)
  
  # resulting table is in a different order to the input list
  # reorder to get the output the right way around
  row.names(genesV2) <- genesV2$HGNC.symbol
  
  mouse_genes <- genesV2[x, 2 ]
  
  return(mouse_genes)
}

humanGenes <- c("TRIB3", "OASL", "BMPER")

convertHumanGeneList(humanGenes)


##########################################################################

mart1 = biomaRt::useMart("ensembl", dataset="hsapiens_gene_ensembl")
mart2 = biomaRt::useMart("ensembl", dataset="mmusculus_gene_ensembl") 

human_ids <- c('ENSG00000109339', 'ENSG00000129990', 
               'ENSG00000132854', 'ENSG00000148204')

# human / mouse
biomaRt::getLDS(attributes=c("ensembl_gene_id"),
       filters="ensembl_gene_id", values=human_ids, mart=mart1,
       attributesL=c("ensembl_gene_id"), martL=mart2)
