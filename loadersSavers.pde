void pdfFileSave(File selection)
{
  if (selection == null) 
  {
    ta.setColor(color(255));
    ta.setText("Status." + "\n" + "Nothing selected, no file saved.");
    //JOptionPane.showMessageDialog(this, "No file saved.", "Error!", JOptionPane.INFORMATION_MESSAGE);
  } 
  else
  {
    if (selection.getName().endsWith(".pdf"))
    {
      pdf = createGraphics(img.width, img.height, PDF, selection.getAbsolutePath());
    }// end if txt
    else
    {
      pdf = createGraphics(img.width, img.height, PDF, selection.getAbsolutePath()+".pdf");
    }// end else end with

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

    ta.setColor(color(0, 255, 0));
    ta.setText("Success." + "\n" + "The File was Saved Successfully!");

    //JOptionPane.showMessageDialog(this, "The File was Saved Successfully!", "Success!", JOptionPane.INFORMATION_MESSAGE);
  }//end else null
}// pdfFileSave

void objFileSave(File selection)
{
  if (selection == null) 
  {
    ta.setColor(color(255));
    ta.setText("Status." + "\n" + "Nothing selected, no file saved.");
  }
  else
  {
    PrintWriter outputOBJ, outputMTL;
    String mtlFileName;
    if (selection.getName().endsWith(".obj"))
    {
      outputOBJ = createWriter(selection.getAbsolutePath());
      outputMTL = createWriter((selection.getAbsolutePath()).replace( ".obj", ".mtl" ));
      mtlFileName = (selection.getName()).replace( ".obj", ".mtl" );
    }// end if txt
    else
    {
      outputOBJ = createWriter(selection.getAbsolutePath()+".obj");
      outputMTL = createWriter(selection.getAbsolutePath()+".mtl");
      mtlFileName = (selection.getName()) + ".mtl";
    }// end else end with

    outputOBJ.println("mtllib " + mtlFileName +"\n");
    
    LinkedHashSet<PVector> pointsDisplay = new LinkedHashSet<PVector>();   
    pointsDisplay = (LinkedHashSet)points.clone(); 
    triangles = new DelaunayTriangulator(pointsDisplay).triangulate();
    
    LinkedHashSet<Integer> colorHash = new LinkedHashSet<Integer>();
    for (int i = 0; i < triangles.size(); i++) 
    {
      Triangle2D t = (Triangle2D)triangles.get(i);

      int ave_x = int((t.a.x + t.b.x + t.c.x)/3);  
      int ave_y = int((t.a.y + t.b.y + t.c.y)/3);
      color img_bColor =  img_b.get(ave_x, ave_y);
      
      String colorRGBName = str((img_bColor >> 16) & 0xFF) + "_" + str((img_bColor >> 8) & 0xFF) + "_" + str(img_bColor & 0xFF);
      
      boolean hasColor = colorHash.contains(img_bColor);
      if (hasColor == false)
      {
        colorHash.add(img_bColor);
        
                    
        String img_b_r = str(((img_bColor >> 16) & 0xFF)/255.0);
        String img_b_g = str(((img_bColor >> 8) & 0xFF)/255.0);
        String img_b_b = str((img_bColor & 0xFF)/255.0);
        
        outputMTL.println("newmtl Colour_" + colorRGBName);
        outputMTL.println("\tNs 32");
        outputMTL.println("\td 1");
        outputMTL.println("\tTr 0");
        outputMTL.println("\tTf 1 1 1");
        outputMTL.println("\tillum 2");
        outputMTL.println("\tKa " + img_b_r + " " + img_b_g + " " + img_b_b);
        outputMTL.println("\tKd " + img_b_r + " " + img_b_g + " " + img_b_b);
        outputMTL.println("\tKs 0.349999994 0.349999994 0.349999994\n");
      }
      
      outputOBJ.println("v " + str(t.a.x) + " " + str(t.a.y) + " 0");
      outputOBJ.println("v " + str(t.b.x) + " " + str(t.b.y) + " 0");
      outputOBJ.println("v " + str(t.c.x) + " " + str(t.c.y) + " 0");
      
      outputOBJ.println("vn 0 1 0");
      outputOBJ.println("g triangle_" + str(i));
      outputOBJ.println("usemtl Colour_" + colorRGBName);
      outputOBJ.println("s 1");
      outputOBJ.println("f " + str(i*3 + 1) + "//" + str(i+1) + " " + str(i*3 + 2) + "//" + str(i+1) + " " + str(i*3 + 3)+ "//" + str(i+1) +"\n");
    }
    
    outputOBJ.flush();  // Writes the remaining data to the file
    outputOBJ.close();  // Finishes the file
    outputMTL.flush();  // Writes the remaining data to the file
    outputMTL.close();  // Finishes the file
    
    ta.setColor(color(0, 255, 0));
    ta.setText("Success." + "\n" + "The File was Saved Successfully!");
  }//end else null
}// end objFileSave

void pointsFileSelect(File selection)
{
  if (selection == null) 
  {
    //println("Window was closed or the user hit cancel.");
  } 
  else
  {
    if (selection.getName().endsWith("txt"))
    {
      // load the image using the given file path
      String lines[] = loadStrings(selection.getPath());     
      String[] width_height = split(lines[0], " ");
      if (parseFloat(width_height[0]) == img.width && parseFloat(width_height[1]) == img.height)
      {
        zoom = 1.0;
        xtrans=0.0;
        ytrans=0.0;
        xzoom=0.0;
        yzoom=0.0;

        noLoop();
        
        points = new LinkedHashSet<PVector>();
        //chosenPointsHash = new LinkedHashSet<PVector>();
        userPointsHash = new LinkedHashSet<PVector>();
        
        for (int i = 1; i < lines.length; i++)
        {
          String[] coords = split(lines[i], ", ");
          String[] coords_x = split(coords[0], "[ ");
          //println (coords);
          float x_ = parseFloat(coords_x[1]);
          float y_ = parseFloat(coords[1]);
          //println(lines[i]);
          points.add(new PVector(x_, y_, 0));
          //int pixelInteger = int(y_*img.width + x_);
          //chosenPointsHash.add(new PVector(x_, y_, 0));
          userPointsHash.add(new PVector(x_, y_, 0));
        }
        loop();
        ta.setColor(color(0, 255, 0));
        ta.setText("Success." + "\n" + "Points are loaded.");
        nCPSlider.setValue(0);
        cPSlider.setValue(0);
      }
      else {
        ta.setColor(color(255, 0, 0));
        ta.setText("Error." + "\n" + "Points file does not match the loaded image.");
        //JOptionPane.showMessageDialog(this, "Points file does not match the loaded image.", "Error!", JOptionPane.INFORMATION_MESSAGE);
      }
    }// end if txt
    else
    {
      ta.setColor(color(255, 0, 0));
      ta.setText("Error." + "\n" + "Please choose a txt file.");
      //JOptionPane.showMessageDialog(this, "Please choose a txt file.", "Error!", JOptionPane.INFORMATION_MESSAGE);
    }
  }//end else null
}//end pointsfileselction


void imageFileSelect(File selection) 
{
  if (selection == null) 
  {
    ta.setColor(color(255));
    ta.setText("Status." + "\n" + "Nothing selected, selection was cancelled.");
  } 
  else 
  {
    if (selection.getName().endsWith("jpg") || selection.getName().endsWith("JPEG")|| selection.getName().endsWith("JPG")|| selection.getName().endsWith("jpeg") || selection.getName().endsWith("png")|| selection.getName().endsWith("PNG")|| selection.getName().endsWith("GIF") || selection.getName().endsWith("gif") || selection.getName().endsWith("tga")|| selection.getName().endsWith("TGA")|| selection.getName().endsWith("tiff")|| selection.getName().endsWith("TIFF")|| selection.getName().endsWith("tif")|| selection.getName().endsWith("TIF"))
    {

      PImage checkImg = loadImage(selection.getAbsolutePath()); 
      // Check if loaded image is valid if invalid should return null or width/height -1
      if (checkImg != null && checkImg.width > 0 && checkImg.height > 0)  
      { 
        img = checkImg.get();

        String Scaled = ""; 
        String extension = "";

        int q = selection.getAbsolutePath().lastIndexOf('.');
        int p = Math.max(selection.getAbsolutePath().lastIndexOf('/'), selection.getAbsolutePath().lastIndexOf('\\'));

        if (q > p) {
          extension = selection.getAbsolutePath().substring(q+1);
        }


        //check image is 60px less than the display
        if (img.width + 60 > displayWidth || img.height + 60 > displayHeight)
        {
          float ratio = float(img.width)/float(img.height);
          //println(ratio);
          int targetHeight = 0;
          int targetWidth = 0;

          if (img.width + 60 > displayWidth)
          {
            targetHeight = int((displayWidth- 60.0)/ratio);  
            targetWidth = displayWidth - 60;
          }
          if (img.height + 60 > displayHeight)
          {
            targetWidth = int((displayHeight - 60.0) * ratio);  
            targetHeight = displayHeight - 60;
          }

          PGraphics scaledImage = createGraphics(targetWidth, targetHeight);

          scaledImage.beginDraw();
          scaledImage.background(0, 0, 0, 0);
          scaledImage.image(img, 0, 0, targetWidth, targetHeight);
          scaledImage.endDraw();

          //println(extension);
          //println(selection.getAbsolutePath().substring(0, q)+"_scaled." + extension);     

          //scaledImage.save(selection.getAbsolutePath().substring(0, q)+"_scaled." + extension);
          //img = loadImage(selection.getAbsolutePath().substring(0, q)+"_scaled." + extension);
          Scaled = (" Original image was too large for your display - scaled to fit");
          img = scaledImage.get(0,0,targetWidth,targetHeight);
        }// end if img is bigger than display
        
        //println(selection.getAbsolutePath());
        img_b = img.get();
        img_c = countourImage(img_b, 1, 80);
        // size the window and show the image 

        surface.setSize(img.width, img.height);
        zoom = 1.0;
        xtrans=0.0;
        ytrans=0.0;
        xzoom=0.0;
        yzoom=0.0;

        //chosenPointsHash = new LinkedHashSet<PVector>();
        userPointsHash = new LinkedHashSet<PVector>();
        points = new LinkedHashSet<PVector>();
        pointsDisplay = new LinkedHashSet<PVector>();
        
        //standard corner points
        points.add(new PVector(0, 0, 0));
        points.add(new PVector(img.width-1, 0, 0));
        points.add(new PVector(img.width-1, img.height-1, 0));
        points.add(new PVector(0, img.height-1, 0));
        points.add(new PVector(img.width/2, img.height/2, 0));
    
        //chosenPointsHash.addAll(points);
        userPointsHash.addAll(points);
        pointsDisplay.addAll(points);
        
        contourImgPoints = getThresholdPixels (img_c, true);
        nonContourPoints = contourImgPoints.get(0);
        contourPoints = contourImgPoints.get(1);
        
        cWSlider.setValue(1);
        cThSlider.setValue(80);
        displayType = Pass.MESH;
        r.activate(Pass.MESH);
        nCPSlider.setValue(0);
        cPSlider.setValue(0);

        ta.setColor(color(0, 255, 0));
        ta.setText("Success." + "\n" + "Image file is loaded." + Scaled);
      } 
      else {
        ta.setColor(color(255, 0, 0));
        ta.setText("Error." + "\n" + "File chosen is not a valid image file.");
      }
    }  
    else
    {
      ta.setColor(color(255, 0, 0));
      ta.setText("Error." + "\n" + "Please choose an image file. (JPEG, JPG, PNG, TGA or GIF).");
      //JOptionPane.showMessageDialog(this, "Please choose an image file. (JPEG, JPG, PNG or GIF)", "Error!", JOptionPane.INFORMATION_MESSAGE);
    }
  }//end else selection
}// end image file selection

void pointsFileSave(File selection)
{
  if (selection == null) 
  {
    ta.setColor(color(255));
    ta.setText("Status." + "\n" + "Nothing selected, no file saved.");
    ///JOptionPane.showMessageDialog(this, "No file saved.", "Error!", JOptionPane.INFORMATION_MESSAGE);
  } 
  else
  {
    if (selection.getName().endsWith(".txt"))
    {
      output = createWriter(selection.getAbsolutePath());
    }// end if txt
    else
    {
      output = createWriter(selection.getAbsolutePath()+".txt");
    }// end else end with

    output.println((img.width) + " " + (img.height));
    
    for (PVector temp : points)
    {
      output.println(temp);
    }
    
    output.flush();  // Writes the remaining data to the file
    output.close();  // Finishes the file
    ta.setColor(color(0, 255, 0));
    ta.setText("Success." + "\n" + "The File was Saved Successfully!");
    //JOptionPane.showMessageDialog(this, "The File was Saved Successfully!", "Success!", JOptionPane.INFORMATION_MESSAGE);
  }//end else null
}// end pointsfilesave