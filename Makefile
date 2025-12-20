# This file is part of The N Browser project, an open-source browser.
# By distributing, modifying or building from source this project, you agree to the license. If you are using the project, as in using the precompiled executable program, you also agree to the license.
# This file was originally made by: dyapan33.

# Define the compiler and flags
CC = g++
CFLAGS = -Wall -std=c++20

# Define include paths
INCLUDES = -I./Src/Vendor/Include/ -I./Src/Vendor/ -I./Src/Vendor/ImGUI/

# Define library search paths
# Consolidated for clarity
LIB_PATHS = -LSrc/Vendor/Lib/

# Define libraries to link, with -lstdc++ explicitly added for chrono dependency
LDFLAGS += -Wl,--enable-auto-import
LIBS = -lstdc++ -lopengl32 -l:glfw3.dll -lgdi32 -lwinmm

# Linking flags
LDFLAGS += -Wl,-rpath,'$$ORIGIN'

# Use `vpath` to tell make where to find the source files
vpath %.cpp Src:Src/Vendor/ImGUI:Src/Vendor/ImGUI/backends

# List C++ source files
CPP_SRC = $(wildcard Src/Vendor/ImGUI/*.cpp) $(wildcard Src/Vendor/ImGUI/backends/*.cpp) $(wildcard Src/*.cpp)
# Use a stem rule for objects to allow finding source files in multiple directories
# See vpath usage above
CPP_OBJ = $(patsubst %.cpp,ObjFiles/%.o, $(notdir $(CPP_SRC)))

# Combine all object files
OBJ = $(CPP_OBJ)

TARGET = Main.exe

# Rule to build the final executable
all: $(TARGET)

# Use a pattern rule for creating object files in the ObjFiles directory
ObjFiles/%.o: %.cpp
	@mkdir -p ObjFiles
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) $(LIB_PATHS) -o $@ $(LDFLAGS) $(LIBS)
	@rm -rf Build
	@mkdir -p Build
	mv $(TARGET) Build/$(TARGET)
	cp ./Src/Vendor/Lib/glfw3.dll ./Build/
	cp ./Src/Vendor/Lib/glfw3dll.lib ./Build/
	cp ./Src/Vendor/Lib/glfw3.lib ./Build/
	cp ./Src/Vendor/Lib/glfw3_mt.lib ./Build/

# Running the file
run:
	sudo ./Build/Main.exe

# Clean up
clean:
	rm -rf ObjFiles Build


