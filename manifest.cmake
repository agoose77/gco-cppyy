 set(_headers
         block.h
         energy.h
         GCoptimization.h
         graph.h
         graph.inl
         LinkedBlockList.h
         maxflow.inl
         )

 set(_sources
         GCoptimization.cpp
         LinkedBlockList.cpp
         )

 foreach (path ${_headers})
     list(APPEND LIB_HEADERS ${CMAKE_SOURCE_DIR}/gco/include/${path})
 endforeach(path)

 foreach (path ${_sources})
     list(APPEND LIB_SOURCES ${CMAKE_SOURCE_DIR}/gco/src/${path})
 endforeach(path)