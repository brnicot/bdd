<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="Z:\DBJGBY~H\bd\vi05\1.xml"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/mesNotes">
	
		<resultatsUML>
			<xsl:for-each select="./etudiant">
				<eleve>
					<nom><xsl:value-of select="nom"/></nom>
					<prenom><xsl:value-of select="prenom"/></prenom>
					<note><xsl:value-of select="./resultat[partiel = 'UML']/note"/></note>
				</eleve>
			</xsl:for-each>
		</resultatsUML>
				
	</xsl:template>
</xsl:stylesheet>

<!-- tester avec ça en 2e ligne <!DOCTYPE resultatsUML SYSTEM "path"> -->