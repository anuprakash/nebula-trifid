#-------------------------------------------------------------------------------
# Toolkit
#-------------------------------------------------------------------------------
INCLUDE_DIRECTORIES(${Nebula3_SOURCE_DIR}/code/application
                    ${Nebula3_SOURCE_DIR}/code/addons									
                    ${Nebula3_SOURCE_DIR}/code/application/basegamefeature
                    ${Nebula3_SOURCE_DIR}/code/application/corefeature
                    ${Nebula3_SOURCE_DIR}/code/application/graphicsfeature
                    ${Nebula3_SOURCE_DIR}/code/application/physicsfeature
                    ${Nebula3_SOURCE_DIR}/code/extlibs									
                    ${Nebula3_SOURCE_DIR}/code/foundation
                    ${Nebula3_SOURCE_DIR}/code/render
                    ${Nebula3_SOURCE_DIR}/code/sui
                    ${Nebula3_SOURCE_DIR}/code/tools		
                    ${Nebula3_SOURCE_DIR}/code/toolkit
                    ${Nebula3_SOURCE_DIR}/code/tests/
                    ${Nebula3_SOURCE_DIR}/code
)


FILE(GLOB SRC "*.cc")
FILE(GLOB HEAD "*.h")
LIST(APPEND SRCS ${SRC} ${HEAD})
SOURCE_GROUP("testfoundation" FILES ${SRCS})

set(PCH_files	
    ../stdneb.cc
)
SOURCE_GROUP("Precompiled" FILES ${PCH_files})

LIST(APPEND ALLSRCS ${SRCS} ${PCH_files})

ADD_EXECUTABLE(testfoundation ${ALLSRCS})
SET_TARGET_PROPERTIES(testfoundation PROPERTIES FOLDER "N3SDK/Tests")

N_SET_COMPILER_DEFAULTS()
N_SET_EXE_LINKER_DEFAULTS(testfoundation)
N_SET_EXE_SUBSYSTEM(testfoundation Console)
IF(N_USE_PRECOMPILED_HEADERS)
    N_SET_PCH(testfoundation stdneb.h stdneb.cc ../)
ENDIF()
ADD_DEPENDENCIES(testfoundation
        foundation
        foundation_NIDLS
        zlib
        tinyxml
        testbase
)
TARGET_LINK_LIBRARIES(testfoundation 
        foundation
        foundation_NIDLS
        zlib
        tinyxml
        testbase
        ${N_LIBS}
)
