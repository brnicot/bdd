<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="Z:\DBJGBY~H\bd\vi05\1.xml"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<html>
			<body>
				<!--
				<xsl:for-each select="mesNotes/etudiant">
					<p>
						<xsl:value-of select="prenom"/>
						-
						<xsl:value-of select="nom"/>
					</p>
				</xsl:for-each>
				-->
				
				<!--
				<xsl:for-each select="mesNotes/etudiant[resultat/partiel = 'UML']">
					<p>
						<xsl:value-of select="position()"/>
						-
						<xsl:value-of select="prenom"/>
						-
						<xsl:value-of select="nom"/>
						<br/>
						note UML :
						<xsl:value-of select="./resultat[partiel = 'UML']/note"/>
					</p>
				</xsl:for-each>
				-->
				
				<!--
				<xsl:for-each select="mesNotes/etudiant[resultat/partiel = 'XML']">
					<p>
						<xsl:value-of select="position()"/>
						-
						<xsl:value-of select="prenom"/>
						-
						<xsl:value-of select="nom"/>
						<br/>
						note XML :
						<xsl:value-of select="./resultat[partiel = 'XML']/note"/>
					</p>
				</xsl:for-each>
				-->
				
				<!--
				<xsl:for-each select="mesNotes/etudiant[not(resultat/partiel = 'UML')]">
					<p>
						<xsl:value-of select="prenom"/>
						-
						<xsl:value-of select="nom"/>
					</p>
				</xsl:for-each>
				-->
				
				<!--
				<xsl:for-each select="mesNotes/etudiant">
					<p>
						<xsl:value-of select="prenom"/>
						-
						<xsl:value-of select="nom"/>
						<br/>
						<xsl:if test="./resultat[partiel = 'UML']">
							note UML : <xsl:value-of select="./resultat[partiel = 'UML']/note"/>
						</xsl:if>
						<xsl:if test="not(./resultat[partiel = 'UML'])">
							pas de note en UML
						</xsl:if>
					</p>
				</xsl:for-each>
				-->
				
				<!--
				<xsl:for-each select="mesNotes/etudiant[resultat/partiel = 'UML']">
					<xsl:sort select="./resultat[partiel = 'UML']/note" data-type="number" order="descending"/>
					<p>
						<xsl:value-of select="@idetud"/>
						-
						<xsl:value-of select="prenom"/>
						-
						<xsl:value-of select="nom"/>
						-
						<xsl:value-of select="./resultat[partiel = 'UML']/note"/>
					</p>
				</xsl:for-each>
				-->
				
				
				<xsl:for-each select="mesNotes/etudiant">
				<xsl:sort select="@idetud" order="ascending"/>
					<p>
						<xsl:value-of select="@idetud"/>
						-
						<xsl:value-of select="prenom"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="nom"/>
						<br/>
						
						<xsl:for-each select="resultat">
							note<xsl:text> </xsl:text>
							<xsl:value-of select="./partiel"/>: <xsl:text> </xsl:text>
							<xsl:value-of select="./note"/>
							<br/>
						</xsl:for-each>
						
					</p>
				</xsl:for-each>
				
				
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
