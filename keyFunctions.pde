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

void globalKeyPressed(char key) {
  switch (key) {
    case 's':
    case 'S':
      saveSvgPdf("output.pdf", PDF);
      break;
    case 'p':
    case 'P':
      displayType = Mode.POINTS;
      modeRadio.activate(Mode.POINTS);
      break;
    case 'r':
    case 'R':
      displayType = Mode.RESULT;
      modeRadio.activate(Mode.RESULT);
      break;
    case 'm':
    case 'M':
      displayType = Mode.MESH;
      modeRadio.activate(Mode.MESH);
      break;
    case 'c':
    case 'C':
      displayType = Mode.CONTOUR;
      modeRadio.activate(Mode.CONTOUR);
      break;
    case 'e':
    case 'E':
      if (deleteMode) 
        eraserToggle.setState(false);
      else  
        eraserToggle.setState(true);
      break;
    case '[':
    case '{':
      if (eraserSize > minEraserSize)
        eraserSize--;
      break;
    case ']':
    case '}':
      if (eraserSize < maxEraserSize)
        eraserSize++;
      break;
    default:
      return;
  }
  redraw();
}
