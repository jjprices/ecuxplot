CLASSPATH_SEP=:

MP_SOURCES=HexValue.java Map.java Parser.java Parse.java \
	ParserException.java Project.java

LF_SOURCES=Dataset.java Units.java CSVFileFilter.java

UT_SOURCES=ExitListener.java WindowUtilities.java Cursors.java WaitCursor.java EChartFactory.java

MP_CLASSES=$(MP_SOURCES:%.java=org/nyet/mappack/%.class)
LF_CLASSES=$(LF_SOURCES:%.java=org/nyet/logfile/%.class)
UT_CLASSES=$(UT_SOURCES:%.java=org/nyet/util/%.class)

TARGETS=mapdump.class ECUxPlot.class
REFERENCE=data/4Z7907551R.kp

CLASSPATH=.$(CLASSPATH_SEP)jcommon-1.0.12.jar$(CLASSPATH_SEP)jfreechart-1.0.9.jar$(CLASSPATH_SEP)opencsv-1.8.jar

JFLAGS=-classpath $(CLASSPATH) -Xlint:deprecation -target 1.5

all: $(TARGETS)
clean:
	rm *.class

%.csv: %.kp mapdump
	./mapdump -r $(REFERENCE) $< > $@

mapdump.class: mapdump.java $(MP_CLASSES)
ECUxPlot.class: ECUxPlot.java $(LF_CLASSES) $(UT_CLASSES)
ECUxPlot.jar: ECUxPlot.class
	jar cfm $@ Manifest.txt ECUxPlot.class `find org/nyet -name \*.class`

ECUxPlot.zip: ECUxPlot.exe
	zip $@ ECUxPlot.exe jcommon-1.0.12.jar jfreechart-1.0.9.jar opencsv-1.8.jar

%.class: %.java
	javac $(JFLAGS) $<
