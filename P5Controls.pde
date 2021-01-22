// Copyright (C) 2021 Ilya Floussov and FOSStriangulator contributors
//
// This file is part of FOSStriangulator.
//
// FOSStriangulator is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 2 only.
//
// FOSStriangulator is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with FOSStriangulator.  If not, see <http://www.gnu.org/licenses/>.

// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded

public class ControlFrame extends PApplet 
{
  int w, h;
  String name;
  PApplet parent;
  ControlP5 controlP5;
  
  public ControlFrame(PApplet _parent, int _w, int _h, String _name) 
  {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    name = _name;
  
    PApplet.runSketch(new String[]{name}, this);
  }
  
  public void settings() 
  {
    size(w, h);
  }
  
  public void setup() 
  {
    surface.setTitle(name);
    surface.setLocation(initWindowLocationX,initWindowLocationY);
    frameRate(25);
    controlP5 = new ControlP5(this);
    
    //UI sizes
    int marginX = 10;
    int groupInsetX = 10;
    int groupWidth = controlFrameWidth - (4*marginX);
    int[] largeButtonSize = {(groupWidth - 2*groupInsetX), 20};
    int sliderWidth = 90 + 90 + 25;
    
    //Color styles 
    controlP5.setColorForeground(Colors.ACCENT_800);
    controlP5.setColorBackground(Colors.BG_800);
    controlP5.setColorActive(Colors.ACCENT_700);
    
    //Components
    openImageBtn = 
    controlP5.addButton("openImageBtn")
    .setPosition(marginX,20)
    .setSize(groupWidth,largeButtonSize[1]+10)
    .plugTo(parent,"openImage")
    .setLabel("Choose an image...")
    .linebreak()
    ;

    loadPtsBtn =  
    controlP5.addButton("loadPtsBtn")
    .setPosition(marginX,openImageBtn.getPosition()[1] + openImageBtn.getHeight() + 10)
    .setSize(groupWidth,largeButtonSize[1]+10)
    .plugTo(parent,"loadPts")
    .setLabel("Load points");
  
    Group generationGroup = 
    controlP5.addGroup("generationGroup")
    .setPosition(marginX,loadPtsBtn.getPosition()[1] + loadPtsBtn.getHeight() + 30)
    .setLabel("Generate points")
    .setBackgroundColor(Colors.BG_950)
    .setSize(groupWidth,130)
    .disableCollapse()
    ;
    
    edgeWeightSlider = 
    controlP5.addSlider("edgeWeightSlider")
    .setPosition(groupInsetX,10)
    .setSize(sliderWidth,largeButtonSize[1])
    .setRange(0,25)
    .setValue(1)
    .setLabel("Edge weight")
    .plugTo(parent,"setEdgeWeight")
    .setGroup(generationGroup)
    ;
    
    edgeThresholdSlider = 
    controlP5.addSlider("edgeThresholdSlider")
    .setPosition(groupInsetX,40)
    .setSize(sliderWidth,largeButtonSize[1])
    .setRange(0,254)
    .setValue(80)
    .setLabel("Edge threshold")
    .plugTo(parent,"setEdgeThreshold")
    .setGroup(generationGroup)
    ;
    
    edgePtsSlider = 
    controlP5.addSlider("edgePtsSlider")
    .setPosition(groupInsetX,70)
    .setSize(sliderWidth,largeButtonSize[1])
    .setRange(0,500)
    .setValue(0)
    .setLabel("# of edge points")
    .plugTo(parent,"setEdgePts")
    .setGroup(generationGroup)
    ;
  
    randomPtsSlider = 
    controlP5.addSlider("randomPtsSlider")
    .setPosition(groupInsetX,100)
    .setSize(sliderWidth,largeButtonSize[1])
    .setRange(0,500)
    .setValue(0)
    .setLabel("# of random points")
    .plugTo(parent,"setRandomPts")
    .setGroup(generationGroup)
    ;
  
    Group eraserGroup = 
    controlP5.addGroup("eraserGroup")
    .setPosition(marginX,generationGroup.getPosition()[1] + generationGroup.getBackgroundHeight() + 30)
    .setLabel("Eraser")
    .setBackgroundColor(Colors.BG_950)
    .setSize(groupWidth,88)
    .disableCollapse()
    ;
  
    eraserToggle =
    controlP5.addToggle("eraserToggle")
    .plugTo(parent,"toggleEraser")
    .setPosition(groupInsetX,groupInsetX)
    .setSize(90,largeButtonSize[1])
    .setLabel("On/off eraser (e)")
    .setGroup(eraserGroup)
    ;

    eraserSizeSlider = 
    controlP5.addSlider("eraserSizeSlider")
    .setPosition(groupInsetX,eraserToggle.getPosition()[1] + eraserToggle.getHeight() + 15 + 10)
    .setSize(sliderWidth,largeButtonSize[1])
    .setRange(minEraserSize,maxEraserSize)
    .setValue(eraserSize)
    .setLabel("Eraser size ([, ])")
    .plugTo(parent,"setEraserSize")
    .setGroup(eraserGroup)
    ;
  
    Group displayGroup = 
    controlP5.addGroup("displayGroup")
    .setPosition(marginX,eraserGroup.getPosition()[1] + eraserGroup.getBackgroundHeight() + 30)
    .setLabel("Display mode")
    .setBackgroundColor(Colors.BG_950)
    .setSize(groupWidth,70)
    .disableCollapse()
    ;
   
    modeRadio = controlP5.addRadioButton("modeRadio")
    .setPosition(groupInsetX,10)
    .setSize(20,largeButtonSize[1])
    .setItemsPerRow(3)
    .setSpacingColumn(90)
    .setSpacingRow(10)
    .addItem("Original (o)",Pass.IMAGE)
    .addItem("Mesh (m)",Pass.MESH)
    .addItem("Contour (c)",Pass.CONTOUR)
    .addItem("Result (r)",Pass.RESULT)
    .activate(Pass.MESH)
    .plugTo(parent,"setMode")
    .setGroup(displayGroup)
    ;
  
    Button savePDFBtn = 
    controlP5.addButton("savePDFBtn")
    .setPosition(marginX,displayGroup.getPosition()[1] + displayGroup.getBackgroundHeight() + 10)
    .setSize(groupWidth,largeButtonSize[1])
    .setLabel("Export to PDF")
    .plugTo(parent,"savePDF")
    ;
       
    Button saveOBJBtn = 
    controlP5.addButton("saveOBJBtn")
    .setPosition(marginX,savePDFBtn.getPosition()[1] + savePDFBtn.getHeight() + 10)
    .setSize(groupWidth,largeButtonSize[1])
    .setLabel("Export to OBJ")
    .plugTo(parent,"saveOBJ")
    ;

    savePtsBtn = 
    controlP5.addButton("savePtsBtn")
    .setPosition(marginX,saveOBJBtn.getPosition()[1] + saveOBJBtn.getHeight() + 10)
    .setSize(groupWidth,largeButtonSize[1])
    .plugTo(parent,"savePts")
    .setLabel("Save points")
    ;
     
    messageArea = 
    controlP5.addTextarea("messageArea")
    .setPosition(marginX,savePtsBtn.getPosition()[1] + 30)
    .setSize(groupWidth,60)
    .setLineHeight(14)
    .setColor(Colors.ON_BG)
    .setColorBackground(Colors.BG_950)
    .setBorderColor(Colors.BG_950)
    .setText("Messages will appear here")  
    ;
  }

  public void draw() 
  {
      background(Colors.BG_900);
  }
  

  public ControlP5 control() 
  {
    return controlP5;
  }

  void keyPressed() 
  {
    if (key == 's' || key == 'S') 
    {
      PGraphics pdf = createGraphics(img.width, img.height, PDF, "output.pdf");
      pdf.beginDraw();
      pdf.noStroke();   
      pdf.image(img, 0, 0);
      LinkedHashSet<PVector> pointsDisplay = new LinkedHashSet<PVector>();  
      pointsDisplay = (LinkedHashSet)points.clone(); 
      triangles = new DelaunayTriangulator(pointsDisplay).triangulate();
      for (int i = 0; i < triangles.size(); i++) 
      {
        Triangle2D t = (Triangle2D)triangles.get(i);
  
        int ave_x = int((t.a.x + t.b.x + t.c.x)/3);  
        int ave_y = int((t.a.y + t.b.y + t.c.y)/3);
  
        pdf.fill( img_b.get(ave_x, ave_y));
  
        pdf.triangle(t.a.x, t.a.y, t.b.x, t.b.y, t.c.x, t.c.y);
      }
      pdf.dispose();
      pdf.endDraw();
      save("output.png");
    }
  
    if (key == 'o' || key == 'O') 
    {
      displayType = Pass.IMAGE;
      modeRadio.activate(Pass.IMAGE);
    }
  
    if (key == 'r' || key == 'R') 
    {
      displayType = Pass.RESULT;
      modeRadio.activate(Pass.RESULT);
    }
  
    if (key == 'm' || key == 'M') 
    {
      displayType = Pass.MESH;
      modeRadio.activate(Pass.MESH);
    }
   
    if (key == 'c' || key == 'C') 
    {
      displayType = Pass.CONTOUR;
      modeRadio.activate(Pass.CONTOUR);
    }
  
    if (key == 'e' || key == 'E') 
    {
      if (deleteMode == true) 
      {
        eraserToggle.setState(false);
      }
      else if (deleteMode == false) 
      {
        eraserToggle.setState(true);
      }
    }
     if ((key == '}' || key == ']') && (eraserSize != maxEraserSize))
    {
      eraserSize = eraserSize + 1;  
    }
    
    if ((key == '{' || key == '[') && (eraserSize != minEraserSize))
    {
      eraserSize = eraserSize - 1;
    }
  }
}
