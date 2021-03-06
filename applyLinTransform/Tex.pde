public static PShape createTex(color col, String latex, PApplet p){
            int id = encode(latex);
            boolean debug = false;
            SVGConverter converter;
            if (!new File(System.getProperty("user.dir") + "\\temp\\" + id + ".svg").exists()) {
                converter = new SVGConverter(col); // TODO: Modify Later
                converter.write(latex, System.getProperty("user.dir") + "\\temp\\" + id + ".svg", 60);
                debug = true;
                p.println("hey im reaching here!",System.getProperty("user.dir"));
            }

            PShape h1gh = p.loadShape(System.getProperty("user.dir") + "\\temp\\" + id + ".svg");//.getChild("eq");
            //h1gh.disableStyle();
            return h1gh;
}

public static int encode(String s){
        return s.replaceAll("\\s+","").hashCode();
    }

import org.apache.batik.dom.GenericDOMImplementation;
import org.apache.batik.svggen.SVGGeneratorContext;
import org.apache.batik.svggen.SVGGraphics2D;
import org.apache.batik.transcoder.TranscoderInput;
import org.apache.batik.transcoder.TranscoderOutput;
import org.apache.fop.render.ps.EPSTranscoder;
import org.apache.fop.render.ps.PSTranscoder;
import org.apache.fop.svg.AbstractFOPTranscoder;
import org.apache.fop.svg.PDFTranscoder;
import org.scilab.forge.jlatexmath.DefaultTeXFont;
import org.scilab.forge.jlatexmath.TeXConstants;
import org.scilab.forge.jlatexmath.TeXFormula;
import org.scilab.forge.jlatexmath.TeXIcon;
import org.scilab.forge.jlatexmath.cyrillic.CyrillicRegistration;
import org.scilab.forge.jlatexmath.greek.GreekRegistration;
import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import javax.swing.*;
import java.awt.*;
import java.io.*;
import java.nio.charset.StandardCharsets;

public static class SVGConverter {

    color col;

    public SVGConverter(color col) {
        this.col = col;
    }

    public static final int PDF = 0;
    public static final int PS = 1;
    public static final int EPS = 2;

    public boolean write(String latex, String file, float size) {
        DOMImplementation domImpl = GenericDOMImplementation.getDOMImplementation();
        String svgNS = "http://www.w3.org/2000/svg";
        Document document = domImpl.createDocument(svgNS, "svg", null);
        SVGGeneratorContext ctx = SVGGeneratorContext.createDefault(document);

        SVGGraphics2D g2 = new SVGGraphics2D(ctx, true);
        DefaultTeXFont.registerAlphabet(new CyrillicRegistration());
        DefaultTeXFont.registerAlphabet(new GreekRegistration());

        TeXFormula formula = new TeXFormula(latex);
        TeXIcon icon = formula.createTeXIcon(TeXConstants.STYLE_DISPLAY, size);
        icon.setInsets(new Insets(0, 0, 0, 0));
        g2.setSVGCanvasSize(new Dimension(icon.getIconWidth(), icon.getIconHeight()));
        g2.setColor(new Color(255, 255, 255, 0)); // Color.WHITE + Transparency
        // g2.fillRect(0, 0, icon.getIconWidth(), icon.getIconHeight());
        JLabel jl = new JLabel();
        jl.setForeground(new Color(col));
        // icon.paintIcon(jl, g2, 0, 0);
        icon.paintIcon(jl, g2, 0, 0);
        Element root = g2.getRoot();
        Element eq = ((Element) root.getChildNodes().item(2));
        eq.setAttribute("id", "eq");
        for (int i = 0; i < eq.getChildNodes().getLength(); i++){
            ((Element) eq.getChildNodes().item(i)).setAttribute("id", String.valueOf(i));
        }
        try {
            FileOutputStream svgs = new FileOutputStream(file);
            Writer out = new OutputStreamWriter(svgs, StandardCharsets.UTF_8);
            g2.stream(root, out, true, false);
            svgs.flush();
            svgs.close();
        } catch (IOException e) {
            System.out.println("hey buddy there's an error here fix it");
            e.printStackTrace();
        }
        return true;
    }

}
