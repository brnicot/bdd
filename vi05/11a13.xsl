<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="Z:\DBJGBY~H\bd\vi05\1.xml"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<html>
			<body>
				
				<xsl:for-each select="//resultat">
					<xsl:value-of select="./partiel[. != preceding-sibling::nom]"/>
				</xsl:for-each>
				
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
