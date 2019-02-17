<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="Z:\DBJGBY~H\bd\vi05\1.xml"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<html>
			<body>
				
				<!--
				<xsl:for-each select="mesNotes/etudiant[count(./resultat) > 1]">
					<p>
						<xsl:value-of select="@idetud"/>
						-
						<xsl:value-of select="prenom"/>
						-
						<xsl:value-of select="nom"/>
					</p>
				</xsl:for-each>	
				-->
				
				<!--
				<xsl:for-each select="mesNotes/etudiant">
					<xsl:sort select="sum(./resultat/note) div count(./resultat)" data-type="number" order="descending"/>
					<p>
						<xsl:value-of select="@idetud"/>
						-
						<xsl:value-of select="prenom"/>
						-
						<xsl:value-of select="nom"/>
						-
						<xsl:value-of select="sum(./resultat/note) div count(./resultat)"/>
					</p>
				</xsl:for-each>
				-->
				
				<xsl:for-each select="mesNotes/etudiant">
					<xsl:sort select="dateNaissance/annee" data-type="number" order="ascending"/>
					<xsl:sort select="dateNaissance/mois" data-type="number" order="ascending"/>
					<xsl:sort select="dateNaissance/jour" data-type="number" order="ascending"/>
					<p>
						<xsl:value-of select="@idetud"/>
						-
						<xsl:value-of select="prenom"/>
						-
						<xsl:value-of select="nom"/>
						-
						<xsl:value-of select="dateNaissance/jour"/>/<xsl:value-of select="dateNaissance/mois"/>/<xsl:value-of select="dateNaissance/annee"/>
					</p>
				</xsl:for-each>
				
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
