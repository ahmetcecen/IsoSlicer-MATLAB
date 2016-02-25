# IsoSlicer-MATLAB

IsoSlicer is a MATLAB GUI tp help create a 3D equivelent of a contourplot for volumetric data. The product is a figure with a series of overlayed transparent iso-layers created using the MATLAB isosurface algorithm. Doesn't require any toolboxes.

## Usage

While it is in your path, simply write IsoSlicer to the command window.

<p align="center"><img src="/GUI.PNG"></p>

## Workflow

First load your data:

**Load (File)** -> Load from a .mat file. Works only if the matfile contains a single variable.

**Load (Workspace)** -> Choose a variable from the workspace. All 3D variables will show up.

Once your data is loaded, the slider at the bottom "Iso-Surface Level" will prime to the right-most position. Simply slide to or enter a contour level and observe a grayscale shade of the current isosurface on the left window. Zoom and Rotate are available on the top toolbar. Once you see an isosurface that you want to include in the final composite ploy:

**Capture Surface** -> Write the isosurface on the left window to the right window.

Keep capturing iso-surfaces at different levels to the right window until you have enough to satisfy your requirements. Once you have all you need, it is time to abandon the left window.

Now focus on the right window. You can select an iso-surface you transfered from the drop down menu. They are numbered by the order you wrote them to the right window. Once you made a selection, you can adjust the transperency using the gray vertical slider, and the rgb values using the color coded vertical sliders to create a vibrant multilayered plot. Once you are satisfied with the plot:

**Export Figure** -> Save the right window to a figure. This figure will have a legend as well based on your color selection and isosurface levels. It will also save the figure as Figure.fig to your working directory.

<p align="center"><img src="/Figure.PNG"></p>
