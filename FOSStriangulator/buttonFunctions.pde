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

public void toggleEraser(boolean eraserOn) 
{
  //println("delete flag set");
  if (eraserOn) 
  {
    deleteMode = true;
    refreshBufferOnce = true;
    pointsDisplay = (LinkedHashSet)points.clone();  
  } 
  else 
  {
    cursor(CROSS);
    deleteMode = false;
    refreshBuffer = true;
    refreshBufferOnce = false;
  }
}

public void openImage() 
{
  refreshBuffer = true;
  selectInput("Select a file to process:", "imageFileSelect");
}

public void loadPts() 
{
  refreshBuffer = true;
  selectInput("Select a points text file:", "pointsFileSelect");
}

public void savePts() 
{
  selectOutput("Save points text file:", "pointsFileSave");
}

public void savePDF()
{
  selectOutput("Save as PDF:", "pdfFileSave");
}

public void saveSVG()
{
  selectOutput("Save as SVG:", "svgFileSave");
}

public void saveOBJ()
{
  selectOutput("Save as OBJ:", "objFileSave");
}

public void setEdgeWeight (int _value) 
{
  if (deleteMode == true){refreshBuffer = true;}
  imgContour = contourImage(img_b, _value, (int)edgeThresholdSlider.getValue());
  contourImgPoints = getThresholdPixels (imgContour, true);
  nonContourPoints = contourImgPoints.get(0);
  contourPoints = contourImgPoints.get(1);
  displayMode = Mode.CONTOUR;
  modeRadio.activate(Mode.CONTOUR);
}

public void setEdgeThreshold (int _value) 
{
  if (deleteMode == true){refreshBuffer = true;}
  imgContour = contourImage(img_b, (int)edgeWeightSlider.getValue(),_value);
  contourImgPoints = getThresholdPixels (imgContour, true);
  nonContourPoints = contourImgPoints.get(0);
  contourPoints = contourImgPoints.get(1);
  displayMode = Mode.CONTOUR;  
  modeRadio.activate(Mode.CONTOUR);
}

public void setMode(int mode) 
{ 
  displayMode = mode;
  modeRadio.activate(mode);

  if (mode == Mode.MESH || mode == Mode.RESULT)
    refreshBuffer = true;
}

//need to resolve this - currently uses the old pvector list need to convert everything to hashset
public void setRandomPts(int pointsNumber)
{
  //noLoop();
  if (deleteMode == true){refreshBuffer = true;}
  LinkedHashSet<PVector> contourPointsHash = new LinkedHashSet<PVector>(sublistIntList(contourPoints, 0, (int)edgePtsSlider.getValue()));
  LinkedHashSet<PVector> nonContourPointsHash = new LinkedHashSet<PVector>(sublistIntList(nonContourPoints, 0, pointsNumber));   
  points = new LinkedHashSet<PVector>();
  pointsDisplay = new LinkedHashSet<PVector>();
  points.addAll(userPointsHash);
  points.addAll(contourPointsHash);
  points.addAll(nonContourPointsHash);
  
  pointsDisplay.addAll(points);

  //println(userPointsHash);
  //loop();
}

public void setEdgePts(int pointsNumber)
{
  //noLoop();
  if (deleteMode == true){refreshBuffer = true;}
  LinkedHashSet<PVector> contourPointsHash = new LinkedHashSet<PVector>(sublistIntList(contourPoints, 0, pointsNumber));
  LinkedHashSet<PVector> nonContourPointsHash = new LinkedHashSet<PVector>(sublistIntList(nonContourPoints, 0, (int)randomPtsSlider.getValue()));   
  points = new LinkedHashSet<PVector>();
  pointsDisplay = new LinkedHashSet<PVector>();
  points.addAll(userPointsHash);
  points.addAll(contourPointsHash);
  points.addAll(nonContourPointsHash);
  
  pointsDisplay.addAll(points);
  //loop();
}

public void setEraserSize(int size)
{
  eraserSize = size;
  eraserToggle.setState(true);
  toggleEraser(true);
}