package Test "Test cases for the ThermoPower models" 
  extends Modelica.Icons.Library;
  
  annotation (Documentation(info="<HTML>
This package contains test cases for the ThermoPower library.
</HTML>"));
  
  annotation (uses(ThermoPower(version="2"), Modelica(version="2.2"),
      UserInteraction(version="0.52")),                                version=
        "1");
  
  package WaterElements "Test for Water package elements except Flow1D models" 
    model TestMixer 
      package Medium=Modelica.Media.Water.StandardWater;
      Water.SourceW SourceW1(w0=0.5, h=2.8e6) 
        annotation(extent=[-90,40; -70,60]);
      Water.SourceW SourceW2(w0=0.5, h=3.0e6) 
        annotation(extent=[-90,0; -70,20]);
      Water.SinkP SinkP1(p0=0) 
                         annotation(extent=[50,20; 70,40]);
      Water.Mixer mixer(
        V=1,
        Cm=0,
        hstart=2.9e6,
        redeclare package Medium = Medium,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                      annotation(extent=[-52,20; -32,40]);
      annotation(Diagram, experiment(StopTime=8),
        Documentation(info="<HTML>
<p>This model tests the <tt>Mixer</tt> and <tt>Header</tt> models.
</HTML>",   revisions="<html>
<ul>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       First release.</li>
</ul>
</html>"));
      Water.ValveLin ValveLin1(Kv=1/1e5) 
                               annotation(extent=[14,20; 34,40]);
      Modelica.Blocks.Sources.Step Step1(
        height=-.2,
        offset=1,
        startTime=2)    annotation(extent=[-44,60; -24,80]);
      Water.PressDrop pressDrop(
        wnom=1,
        dpnom=100,
        rhonom=1000,
        redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint) 
                     annotation(extent=[-20,20; 0,40]);
      Water.SourceW SourceW3(w0=0.5, h=2.8e6) 
        annotation(extent=[-90,-40; -70,-20]);
      Water.Header header(
        V=1,
        redeclare package Medium = Medium,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
        annotation(extent=[-40,-40; -20,-20]);
      Water.ValveLin ValveLin2(Kv=1/1e5) 
                               annotation(extent=[-2,-40; 18,-20]);
      Water.SinkP SinkP2(p0=0) 
                         annotation(extent=[40,-40; 60,-20]);
    equation 
      connect(SourceW1.flange, mixer.in1) 
        annotation(points=[-70,50; -60,50; -60,36; -50,36], style(thickness=2));
      connect(SourceW2.flange, mixer.in2) 
        annotation(points=[-70,10; -60,10; -60,24; -49.9,24], style(thickness=2));
      connect(ValveLin1.outlet, SinkP1.flange) 
        annotation(points=[34,30; 50,30], style(thickness=2));
      connect(pressDrop.outlet, ValveLin1.inlet) 
        annotation(points=[0,30; 14,30], style(thickness=2));
      connect(mixer.out, pressDrop.inlet)   annotation(points=[-32,30; -20,30],
          style(thickness=2));
      connect(SourceW3.flange, header.inlet) 
        annotation(points=[-70,-30; -40.1,-30], style(thickness=2));
      connect(header.outlet, ValveLin2.inlet) 
        annotation(points=[-20,-30; -2,-30], style(thickness=2));
      connect(ValveLin2.outlet, SinkP2.flange) 
        annotation(points=[18,-30; 40,-30], style(thickness=2));
      connect(Step1.y, ValveLin1.cmd) annotation (points=[-23,70; 24,70; 24,38],
          style(color=74, rgbcolor={0,0,127}));
      connect(Step1.y, ValveLin2.cmd) annotation (points=[-23,70; 8,70; 8,-22],
          style(color=74, rgbcolor={0,0,127}));
    end TestMixer;
    
    model TestMixerSlowFast 
     // package Medium=Modelica.Media.Water.StandardWater;
     package Medium=Media.LiquidWaterConstant;
      Water.SourceW SourceW1(w0=0.5, h=1e5,
        redeclare package Medium = Medium) 
        annotation(extent=[-98,10; -78,30]);
      Water.SourceW SourceW2(w0=0.5, h=2e5,
        redeclare package Medium = Medium) 
        annotation(extent=[-98,-30; -78,-10]);
      Water.SinkP SinkP1(p0=1e5, redeclare package Medium = Medium) 
                         annotation(extent=[80,-10; 100,10]);
      Water.Mixer Mixer1(
        hstart=1e5,
        V=0.01,
        redeclare package Medium = Medium,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                      annotation(extent=[-60,-10; -40,10]);
      annotation(Diagram, experiment(StopTime=50, NumberOfIntervals=5000),
        Documentation(info="<HTML>
<p>This model tests the <tt>Mixer</tt> and <tt>Header</tt> models with different medium models. If an incompressible medium model is used, the fast pressure dynamics is neglected, thus allowing simulation with explicit algorithms and large time steps.
</HTML>", revisions="<html>
<ul>
<li><i>24 Sep 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       First release.</li>
</ul>
</html>"));
      Water.ValveLin ValveLin1(Kv=1/1e5, redeclare package Medium = Medium) 
                               annotation(extent=[38,-10; 58,10]);
      Modelica.Blocks.Sources.Step StepValv(
        height=-.2,
        offset=1,
        startTime=2)    annotation(extent=[14,30; 34,50]);
      Water.PressDrop PressDrop1(
        wnom=1,
        dpnom=100,
        rhonom=1000,
        redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint) 
                     annotation(extent=[-30,-10; -10,10]);
      Water.Header Header1(
        hstart=1e5,
        V=0.01,
        redeclare package Medium = Medium,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
        annotation(extent=[0,-10; 20,10]);
      Modelica.Blocks.Sources.Step StepEnthalpy(
        height=1e5,
        offset=1e5,
        startTime=4)    annotation(extent=[-92,50; -72,70]);
    equation 
      connect(SourceW1.flange, Mixer1.in1) 
        annotation(points=[-78,20; -66,20; -66,6; -58,6], style(thickness=2));
      connect(SourceW2.flange, Mixer1.in2) 
        annotation(points=[-78,-20; -66,-20; -66,-6; -57.9,-6], style(thickness=2));
      connect(ValveLin1.outlet, SinkP1.flange) 
        annotation(points=[58,0; 80,0], style(thickness=2));
      connect(Mixer1.out, PressDrop1.inlet) annotation(points=[-40,0; -30,0],
          style(thickness=2));
      connect(PressDrop1.outlet, Header1.inlet) 
        annotation (points=[-10,0; -0.1,0], style(thickness=2));
      connect(Header1.outlet, ValveLin1.inlet) 
        annotation (points=[20,0; 38,0], style(thickness=2));
      connect(StepEnthalpy.y, SourceW1.in_h) annotation (points=[-71,60; -60,60;
            -60,40; -84,40; -84,26], style(color=74, rgbcolor={0,0,127}));
      connect(StepValv.y, ValveLin1.cmd) annotation (points=[35,40; 48,40; 48,8],
          style(color=74, rgbcolor={0,0,127}));
    end TestMixerSlowFast;
    
    model TestPressDrop 
      package Medium=Modelica.Media.Water.StandardWater;
      Water.SourceP SourceP1(p0=3e5) annotation (extent=[-78,60; -58,80]);
      Water.SinkP SinkP1(p0=1e5) annotation (extent=[40,60; 60,80]);
      annotation (Diagram, Documentation(info="<html>
This test model demonstrate four possible ways of setting the friction coefficient for the <tt>PressDrop</tt> model.
<ol>
<li>The friction factor coefficient can be specified directly, by setting <tt>FFtype=0</tt> and the appropriate value to <tt>Kf</tt>.
<li>The friction factor needed to obtain certain conditions can be set by initial equations. In this case, <tt>FFtype=0</tt>, and <tt>Kf=Kf_unknown</tt>, with <tt>Kf_unknown</tt> having a fixed=false attribute. The latter parameter is then determined by an initial equation (e.g. by assigning the initial mass flow rate).
<li>The friction factor can be specified by setting <tt>FFtype=1</tt>, and then by assigning the nominal pressure drop <tt>dpnom</tt> corresponding to the nominal flow rate <tt>wnom</tt> and to the nominal density <tt>rhonom</tt>.
<li>The pressure drop can be specified as a given multiple of the kinetic pressure, by setting <tt>FFtype=2</tt> and assigning the multiplicative coefficient <tt>K</tt>.
</ol>
</html>", revisions="<html>
<ul>
    <li><i>18 Nov 2004</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>: 
    <br>First release.</li>
</ul>
</html>"));
      parameter Real Kf_unknown(fixed=false);
      Water.SourceP SourceP3(p0=3e5) annotation (extent=[-80,-20; -60,0]);
      Water.SinkP SinkP3(p0=1e5) annotation (extent=[40,-20; 60,0]);
      Water.PressDrop PressDrop3a(
        redeclare package Medium = Medium,
        wnom=1,
        dpnom=1e5,
        rhonom=1000,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint) 
                                           annotation (extent=[-40,-20; -20,0]);
      Water.PressDrop PressDrop3b(
        redeclare package Medium = Medium,
        wnom=1,
        dpnom=1e5,
        rhonom=1000,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint) 
                                           annotation (extent=[0,-20; 20,0]);
      Water.SourceP SourceP4(p0=3e5) annotation (extent=[-80,-60; -60,-40]);
      Water.SinkP SinkP4(p0=1e5) annotation (extent=[40,-60; 60,-40]);
      Water.PressDrop PressDrop4a(
        redeclare package Medium = Medium,
        K=1,
        A=1e-4,
        wnom=1,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.Kinetic) 
                                           annotation (extent=[-40,-60; -20,-40]);
      Water.PressDrop PressDrop4b(
        redeclare package Medium = Medium,
        wnom=1,
        K=1,
        A=1e-4,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.Kinetic) 
                                           annotation (extent=[0,-60; 20,-40]);
      Water.SourceP SourceP2(p0=3e5) annotation (extent=[-80,20; -60,40]);
      Water.SinkP SinkP2(p0=1e5) annotation (extent=[40,20; 60,40]);
      Water.PressDrop PressDrop2a(
        redeclare package Medium = Medium,
        wnom=1,
        Kf=Kf_unknown,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.Kf) 
                   annotation (extent=[-40,20; -20,40]);
      Water.PressDrop PressDrop2b(
        redeclare package Medium = Medium,
        wnom=1,
        Kf=Kf_unknown,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.Kf) 
                   annotation (extent=[0,20; 20,40]);
      Water.PressDrop PressDrop1a(
        wnom=1,
        Kf=1e8,
        redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.Kf) 
                                           annotation (extent=[-40,60; -20,80]);
      Water.PressDrop PressDrop1b(redeclare package Medium = Medium,
        wnom=1,
        Kf=1e8,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.Kf) 
        annotation (extent=[0,60; 20,80]);
    initial equation 
      PressDrop2a.inlet.w=1;
    equation 
      connect(SourceP3.flange, PressDrop3a.inlet) 
        annotation (points=[-60,-10; -40,-10], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(PressDrop3a.outlet, PressDrop3b.inlet) 
        annotation (points=[-20,-10; 0,-10], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(PressDrop3b.outlet, SinkP3.flange) 
                                                annotation (points=[20,-10; 40,
            -10], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SourceP4.flange, PressDrop4a.inlet) 
        annotation (points=[-60,-50; -40,-50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(PressDrop4a.outlet, PressDrop4b.inlet) 
        annotation (points=[-20,-50; 0,-50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(PressDrop4b.outlet, SinkP4.flange) 
                                                annotation (points=[20,-50; 40,
            -50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SourceP2.flange,PressDrop2a. inlet) 
        annotation (points=[-60,30; -40,30], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(PressDrop2a.outlet,PressDrop2b. inlet) 
        annotation (points=[-20,30; 0,30], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(PressDrop2b.outlet,SinkP2. flange) 
                                                annotation (points=[20,30; 40,30],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SourceP1.flange, PressDrop1a.inlet) 
        annotation (points=[-58,70; -40,70], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(PressDrop1a.outlet, PressDrop1b.inlet) 
        annotation (points=[-20,70; 0,70], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(PressDrop1b.outlet, SinkP1.flange) 
        annotation (points=[20,70; 40,70], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
    end TestPressDrop;
    
    model TestThroughW "Test of the ThroughW component" 
      
      Water.SourceP SourceP1 annotation (extent=[-80,10; -60,30]);
      Water.PressDropLin PressDropLin1(R=1e5/1) annotation (extent=[0,10; 20,30]);
      Water.ThroughW ThroughW1(w0=2) annotation (extent=[-40,10; -20,30]);
      Water.SinkP SinkP1 annotation (extent=[40,10; 60,30]);
      annotation (Diagram, Documentation(revisions="<html>
<ul>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       First release.</li>
</ul>
</html>"));
      Water.SourceP SourceP2 annotation (extent=[-80,-50; -60,-30]);
      Water.PressDropLin PressDropLin2(R=1e5/1) 
        annotation (extent=[0,-50; 20,-30]);
      Water.ThroughW ThroughW2(w0=2) annotation (extent=[-40,-50; -20,-30]);
      Water.SinkP SinkP2 annotation (extent=[40,-50; 60,-30]);
      Modelica.Blocks.Sources.Step Step1(
        height=1,
        offset=2,
        startTime=0.5) annotation (extent=[-60,-20; -40,0]);
    equation 
      connect(ThroughW1.outlet, PressDropLin1.inlet) 
        annotation (points=[-20,20; 0,20], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SourceP1.flange, ThroughW1.inlet) 
        annotation (points=[-60,20; -40,20], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(PressDropLin1.outlet, SinkP1.flange) 
        annotation (points=[20,20; 40,20], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(ThroughW2.outlet, PressDropLin2.inlet) 
        annotation (points=[-20,-40; 0,-40], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SourceP2.flange, ThroughW2.inlet) 
        annotation (points=[-60,-40; -40,-40], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(PressDropLin2.outlet, SinkP2.flange) 
        annotation (points=[20,-40; 40,-40], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Step1.y, ThroughW2.in_w0) annotation (points=[-39,-10; -34,-10; -34,
            -34], style(color=74, rgbcolor={0,0,127}));
    end TestThroughW;
    
    model TwoTanks "Test case for Tank and Flow1D" 
      annotation (
        Diagram,
        experiment(StopTime=20, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>This model tests the <tt>Tank</tt> model and the <tt>Flow1D</tt> model in reversing flow conditions.</p>
<p>Simulate the model for 20 s: flow oscillations arise from the combination of inertial effects in the pipe and from the hydraulic capacitance of the tanks. The temperature within the pipe evolves accordingly. </p>
</HTML>",   revisions="<html>
<ul>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       First release.</li>
</ul>
</html>"),
        experimentSetupOutput);
      ThermoPower.Water.Tank Tank2(
        A=0.1,
        pext=1e5,
        redeclare package Medium = Modelica.Media.Water.WaterIF97OnePhase_ph) 
        annotation (extent=[20, -4; 40, 16]);
      ThermoPower.Water.Flow1D Pipe(
        N=5,
        L=1,
        omega=0.314,
        Dhyd=0.1,
        A=0.01,
        rhonom=1000,
        wnom=40,
        dpnom=20,
        wnf=0.01,
        Cfnom=0.005,
        DynamicMomentum=true,
        redeclare package Medium = Modelica.Media.Water.WaterIF97OnePhase_ph,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom) 
                              annotation (extent=[-20, -10; 0, 10]);
      ThermoPower.Water.Tank Tank1(
        A=0.1,
        pext=1e5,
        redeclare package Medium = Modelica.Media.Water.WaterIF97OnePhase_ph) 
        annotation (extent=[-60, -4; -40, 16]);
      ThermoPower.Water.SourceW Plug1(w0=0) 
        annotation (extent=[-100,-10; -80,10]);
      ThermoPower.Water.SinkW Plug2(w0=0) annotation (extent=[60, -10; 80, 10]);
    equation 
      connect(Pipe.outfl, Tank2.inlet) annotation (points=[0,0; 22,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Tank1.outlet, Pipe.infl) annotation (points=[-42,0; -20,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Plug1.flange, Tank1.inlet) annotation (points=[-80,0; -58,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Tank2.outlet, Plug2.flange) annotation (points=[38, 0; 60, 0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
    initial equation 
      Tank1.h = 2e5;
      Tank1.y = 2;
      Tank2.h = 1e5;
      Tank2.y = 1;
    end TwoTanks;
    
    model TestJoin "Test case FlowJoin and FlowSplit" 
      package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      constant Real pi=Modelica.Constants.pi;
      ThermoPower.Water.SourceW S1(h=1e5) 
        annotation (extent=[-58,50; -38,70]);
      ThermoPower.Water.SourceW S2(h=2e5) 
        annotation (extent=[-58,10; -38,30]);
      ThermoPower.Water.SinkW S5(h=2e5) 
        annotation (extent=[60,-44; 80,-24]);
      ThermoPower.Water.SinkW S6(h=3e5) 
        annotation (extent=[60,-96; 80,-76]);
      ThermoPower.Water.FlowJoin FlowJoin1 annotation (extent=[-10,30; 10,50]);
      ThermoPower.Water.FlowSplit FlowSplit1 
        annotation (extent=[-4, -70; 16, -50]);
      annotation (
        Diagram,
        experiment(StopTime=4, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>This model tests the <tt>FlowJoin</tt> and the <tt>FlowSplit</tt> models in all the possible flow configurations.
<p>Simulate the model for 4 s and observe the temperatures measured by the different sensors as the flows change.
</HTML>",   revisions="<html>
<ul>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       First release.</li>
</ul>
</html>"));
      ThermoPower.Water.SinkP S3(h=3e5) annotation (extent=[70,30; 90,50]);
      ThermoPower.Water.PressDropLin LossP1(R=1e-5) 
        annotation (extent=[40,30; 60,50]);
      ThermoPower.Water.PressDropLin LossP2(R=1e-5) 
        annotation (extent=[-60,-70; -40,-50]);
      ThermoPower.Water.SourceP S4(h=1e5) 
        annotation (extent=[-90,-70; -70,-50]);
      Modelica.Blocks.Sources.Sine Sine1(
        amplitude=1,
        freqHz=1,
        phase=pi/2,
        offset=0,
        startTime=0)                     annotation (extent=[-90,70; -70,90]);
      Modelica.Blocks.Sources.Sine Sine2(freqHz=0.5,
        amplitude=1,
        phase=pi/2,
        offset=0,
        startTime=0) 
        annotation (extent=[-90,30; -70,50]);
      ThermoPower.Water.SensT T1(redeclare package Medium = 
            Medium)              annotation (extent=[-32,54; -12,74]);
      ThermoPower.Water.SensT T2(redeclare package Medium = 
            Medium)              annotation (extent=[-32,14; -12,34]);
      ThermoPower.Water.SensT T3(redeclare package Medium = 
            Medium)              annotation (extent=[14,34; 34,54]);
      ThermoPower.Water.SensT T4(redeclare package Medium = 
            Medium)              annotation (extent=[-30,-66; -10,-46]);
      ThermoPower.Water.SensT T5(redeclare package Medium = 
            Medium)              annotation (extent=[20,-40; 40,-20]);
      ThermoPower.Water.SensT T6(redeclare package Medium = 
            Medium)              annotation (extent=[20,-92; 40,-72]);
      Modelica.Blocks.Sources.Sine Sine3(freqHz=1,
        amplitude=1,
        phase=pi/2,
        offset=0,
        startTime=0) 
        annotation (extent=[34,-16; 54,4]);
      Modelica.Blocks.Sources.Sine Sine4(freqHz=0.5,
        amplitude=1,
        phase=pi/2,
        offset=0,
        startTime=0) 
        annotation (extent=[34,-66; 54,-46]);
      ThermoPower.Water.SensP P1 annotation (extent=[-50,-48; -30,-28]);
    equation 
      connect(LossP1.outlet, S3.flange) 
        annotation (points=[60,40; 70,40], style(thickness=2, fillPattern=1));
      connect(S4.flange, LossP2.inlet) 
        annotation (points=[-70,-60; -60,-60], style(thickness=2, fillPattern=1));
      connect(S1.flange, T1.inlet) annotation (points=[-38,60; -28,60], style(
            thickness=2));
      connect(S2.flange, T2.inlet) annotation (points=[-38,20; -28,20], style(
            thickness=2));
      connect(FlowJoin1.out, T3.inlet) annotation (points=[6,40; 18,40], style(
            thickness=2));
      connect(T3.outlet, LossP1.inlet) annotation (points=[30,40; 40,40], style(
            thickness=2));
      connect(LossP2.outlet, T4.inlet) annotation (points=[-40,-60; -26,-60],
          style(thickness=2));
      connect(T4.outlet, FlowSplit1.in1) annotation (points=[-14,-60; 0,-60],
          style(thickness=2));
      connect(T5.outlet, S5.flange) annotation (points=[36,-34; 60,-34], style(
            thickness=2));
      connect(T6.outlet, S6.flange) annotation (points=[36,-86; 60,-86], style(
            thickness=2));
      connect(P1.flange, LossP2.outlet) 
        annotation (points=[-40,-42; -40,-60]);
      connect(Sine1.y, S1.in_w0) annotation (points=[-69,80; -52,80; -52,66],
          style(color=74, rgbcolor={0,0,127}));
      connect(Sine2.y, S2.in_w0) annotation (points=[-69,40; -52,40; -52,26],
          style(color=74, rgbcolor={0,0,127}));
      connect(Sine4.y, S6.in_w0) annotation (points=[55,-56; 66,-56; 66,-80],
          style(color=74, rgbcolor={0,0,127}));
      connect(Sine3.y, S5.in_w0) annotation (points=[55,-6; 66,-6; 66,-28], style(
            color=74, rgbcolor={0,0,127}));
      connect(T2.outlet, FlowJoin1.in2) 
        annotation (points=[-16,20; -16,20; -6,36], style(thickness=2));
      connect(FlowJoin1.in1, T1.outlet) 
        annotation (points=[-6,44; -16,60], style(thickness=2));
      connect(T5.inlet, FlowSplit1.out1) 
        annotation (points=[24,-34; 24,-34; 12,-55.8], style(thickness=2));
      connect(T6.inlet, FlowSplit1.out2) 
        annotation (points=[24,-86; 24,-86; 12,-64], style(thickness=2));
    end TestJoin;
    
    model TestJoinRev "Test case FlowJoin" 
      package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      constant Real pi=Modelica.Constants.pi;
      ThermoPower.Water.SourceW S1(h=1e5, w0=2) 
        annotation (extent=[-58,50; -38,70]);
      ThermoPower.Water.SourceW S2(h=2e5) 
        annotation (extent=[-58,10; -38,30]);
      ThermoPower.Water.FlowJoin FlowJoin1 annotation (extent=[-10,30; 10,50]);
      annotation (
        Diagram,
        experiment(StopTime=4, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>This model tests the <tt>FlowJoin</tt> models in all the possible flow configurations, both allowed and not allowed flow reversal.
<p>Simulate the model for 7 s and observe the temperatures measured by the different sensors as the flows change.
</HTML>",   revisions="<html>
<ul>
<li><i>3 Dec 2008</i>
     by <a>Luca Savoldelli</a>:<br>
       First release.</li>
</ul>
</html>"));
      ThermoPower.Water.SinkP S3(h=3e5) annotation (extent=[70,30; 90,50]);
      ThermoPower.Water.PressDropLin LossP1(R=1e-5) 
        annotation (extent=[40,30; 60,50]);
      ThermoPower.Water.SensT T1(redeclare package Medium = 
            Medium)              annotation (extent=[-32,54; -12,74]);
      ThermoPower.Water.SensT T2(redeclare package Medium = 
            Medium)              annotation (extent=[-32,14; -12,34]);
      ThermoPower.Water.SensT T3(redeclare package Medium = 
            Medium)              annotation (extent=[14,34; 34,54]);
      Modelica.Blocks.Sources.Trapezoid Sine1(
        nperiod=2,
        rising=0.5,
        width=0.5,
        falling=0.5,
        period=4,
        offset=1,
        startTime=0.5,
        amplitude=-1.2) 
        annotation (extent=[-90,70; -70,90]);
      Modelica.Blocks.Sources.Trapezoid Sine2(
        nperiod=2,
        rising=0.5,
        width=0.5,
        falling=0.5,
        offset=1,
        startTime=2.5,
        period=2,
        amplitude=-1.2) 
        annotation (extent=[-90,30; -70,50]);
      ThermoPower.Water.SourceW S4(h=1e5, w0=2) 
        annotation (extent=[-58,-30; -38,-10]);
      ThermoPower.Water.SourceW S5(h=2e5) 
        annotation (extent=[-58,-70; -38,-50]);
      ThermoPower.Water.FlowJoin FlowJoin2(
        rev_in1=false,
        rev_in2=false,
        rev_out=false)                     annotation (extent=[-10,-50; 10,-30]);
      ThermoPower.Water.SinkP S6(h=3e5) annotation (extent=[70,-50; 90,-30]);
      ThermoPower.Water.PressDropLin LossP2(R=1e-5) 
        annotation (extent=[40,-50; 60,-30]);
      ThermoPower.Water.SensT T4(redeclare package Medium = 
            Medium)              annotation (extent=[-32,-26; -12,-6]);
      ThermoPower.Water.SensT T5(redeclare package Medium = 
            Medium)              annotation (extent=[-32,-66; -12,-46]);
      ThermoPower.Water.SensT T6(redeclare package Medium = 
            Medium)              annotation (extent=[14,-46; 34,-26]);
      Modelica.Blocks.Sources.Trapezoid Sine3(
        nperiod=2,
        rising=0.5,
        width=0.5,
        falling=0.5,
        period=4,
        offset=1,
        startTime=0.5,
        amplitude=-1.2) 
        annotation (extent=[-90,-10; -70,10]);
      Modelica.Blocks.Sources.Trapezoid Sine4(
        nperiod=2,
        rising=0.5,
        width=0.5,
        falling=0.5,
        offset=1,
        startTime=2.5,
        period=2,
        amplitude=-1.2) 
        annotation (extent=[-90,-50; -70,-30]);
    equation 
      connect(LossP1.outlet, S3.flange) 
        annotation (points=[60,40; 70,40], style(thickness=2, fillPattern=1));
      connect(S1.flange, T1.inlet) annotation (points=[-38,60; -28,60], style(
            thickness=2));
      connect(S2.flange, T2.inlet) annotation (points=[-38,20; -28,20], style(
            thickness=2));
      connect(FlowJoin1.out, T3.inlet) annotation (points=[6,40; 18,40], style(
            thickness=2));
      connect(T3.outlet, LossP1.inlet) annotation (points=[30,40; 40,40], style(
            thickness=2));
      connect(T2.outlet, FlowJoin1.in2) 
        annotation (points=[-16,20; -16,20; -6,36], style(thickness=2));
      connect(FlowJoin1.in1, T1.outlet) 
        annotation (points=[-6,44; -16,60], style(thickness=2));
      connect(Sine2.y, S2.in_w0) annotation (points=[-69,40; -52,40; -52,26],
          style(color=74, rgbcolor={0,0,127}));
      connect(Sine1.y, S1.in_w0) annotation (points=[-69,80; -52,80; -52,66],
          style(color=74, rgbcolor={0,0,127}));
      connect(LossP2.outlet,S6. flange) 
        annotation (points=[60,-40; 70,-40], style(thickness=2, fillPattern=1));
      connect(S4.flange,T4. inlet) annotation (points=[-38,-20; -28,-20], style(
            thickness=2));
      connect(S5.flange,T5. inlet) annotation (points=[-38,-60; -28,-60], style(
            thickness=2));
      connect(FlowJoin2.out,T6. inlet) annotation (points=[6,-40; 18,-40], style(
            thickness=2));
      connect(T6.outlet,LossP2. inlet) annotation (points=[30,-40; 40,-40], style(
            thickness=2));
      connect(T5.outlet, FlowJoin2.in2) 
        annotation (points=[-16,-60; -16,-60; -6,-44], style(thickness=2));
      connect(FlowJoin2.in1, T4.outlet) 
        annotation (points=[-6,-36; -16,-20], style(thickness=2));
      connect(Sine4.y, S5.in_w0) annotation (points=[-69,-40; -52,-40; -52,-54],
          style(color=74, rgbcolor={0,0,127}));
      connect(Sine3.y, S4.in_w0) annotation (points=[-69,0; -52,0; -52,-14],
          style(color=74, rgbcolor={0,0,127}));
    end TestJoinRev;
    
    model TestSplitRev "Test case FlowSplit" 
      package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      constant Real pi=Modelica.Constants.pi;
      ThermoPower.Water.SinkW S5(h=2e5) 
        annotation (extent=[60,-44; 80,-24]);
      ThermoPower.Water.SinkW S6(h=3e5) 
        annotation (extent=[60,-96; 80,-76]);
      ThermoPower.Water.FlowSplit FlowSplit2(
        rev_in1=false,
        rev_out1=false,
        rev_out2=false) 
        annotation (extent=[-4, -70; 16, -50]);
      annotation (
        Diagram,
        experiment(StopTime=4, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>This model tests the <tt>FlowSplit</tt> models in all the possible flow configurations, both allowed and not allowed flow reversal.
<p>Simulate the model for 7 s and observe the temperatures measured by the different sensors as the flows change.
</HTML>",   revisions="<html>
<ul>
<li><i>3 Dec 2008</i>
     by <a>Luca Savoldelli</a>:<br>
       First release.</li>
</ul>
</html>"));
      ThermoPower.Water.PressDropLin LossP2(R=1e-5) 
        annotation (extent=[-60,-70; -40,-50]);
      ThermoPower.Water.SourceP S4(h=1e5) 
        annotation (extent=[-90,-70; -70,-50]);
      ThermoPower.Water.SensT T4(redeclare package Medium = 
            Medium)              annotation (extent=[-30,-66; -10,-46]);
      ThermoPower.Water.SensT T5(redeclare package Medium = 
            Medium)              annotation (extent=[20,-40; 40,-20]);
      ThermoPower.Water.SensT T6(redeclare package Medium = 
            Medium)              annotation (extent=[20,-92; 40,-72]);
      ThermoPower.Water.SensP P1 annotation (extent=[-50,-48; -30,-28]);
      Modelica.Blocks.Sources.Trapezoid Sine3(
        nperiod=2,
        rising=0.5,
        width=0.5,
        falling=0.5,
        period=4,
        offset=1,
        startTime=0.5,
        amplitude=-1.2) 
        annotation (extent=[0,-20; 20,0]);
      Modelica.Blocks.Sources.Trapezoid Sine4(
        nperiod=2,
        rising=0.5,
        width=0.5,
        falling=0.5,
        offset=1,
        startTime=2.5,
        period=2,
        amplitude=-1.2) 
        annotation (extent=[40,-70; 60,-50]);
      ThermoPower.Water.SinkW S1(h=2e5) 
        annotation (extent=[60,52; 80,72]);
      ThermoPower.Water.SinkW S2(h=3e5) 
        annotation (extent=[60,0; 80,20]);
      ThermoPower.Water.FlowSplit FlowSplit1 
        annotation (extent=[-4,26; 16,46]);
      ThermoPower.Water.PressDropLin LossP1(R=1e-5) 
        annotation (extent=[-60,26; -40,46]);
      ThermoPower.Water.SourceP S3(h=1e5) 
        annotation (extent=[-90,26; -70,46]);
      ThermoPower.Water.SensT T1(redeclare package Medium = 
            Medium)              annotation (extent=[-30,30; -10,50]);
      ThermoPower.Water.SensT T2(redeclare package Medium = 
            Medium)              annotation (extent=[20,56; 40,76]);
      ThermoPower.Water.SensT T3(redeclare package Medium = 
            Medium)              annotation (extent=[20,4; 40,24]);
      ThermoPower.Water.SensP P2 annotation (extent=[-50,48; -30,68]);
      Modelica.Blocks.Sources.Trapezoid Sine1(
        nperiod=2,
        rising=0.5,
        width=0.5,
        falling=0.5,
        period=4,
        offset=1,
        startTime=0.5,
        amplitude=-1.2) 
        annotation (extent=[0,76; 20,96]);
      Modelica.Blocks.Sources.Trapezoid Sine2(
        nperiod=2,
        rising=0.5,
        width=0.5,
        falling=0.5,
        offset=1,
        startTime=2.5,
        period=2,
        amplitude=-1.2) 
        annotation (extent=[40,26; 60,46]);
    equation 
      connect(S4.flange, LossP2.inlet) 
        annotation (points=[-70,-60; -60,-60], style(thickness=2, fillPattern=1));
      connect(LossP2.outlet, T4.inlet) annotation (points=[-40,-60; -26,-60],
          style(thickness=2));
      connect(T4.outlet,FlowSplit2. in1) annotation (points=[-14,-60; 0,-60],
          style(thickness=2));
      connect(T5.outlet, S5.flange) annotation (points=[36,-34; 60,-34], style(
            thickness=2));
      connect(T6.outlet, S6.flange) annotation (points=[36,-86; 60,-86], style(
            thickness=2));
      connect(P1.flange, LossP2.outlet) 
        annotation (points=[-40,-42; -40,-60]);
      connect(T5.inlet, FlowSplit2.out1) 
        annotation (points=[24,-34; 24,-34; 12,-55.8], style(thickness=2));
      connect(T6.inlet, FlowSplit2.out2) 
        annotation (points=[24,-86; 24,-86; 12,-64], style(thickness=2));
      connect(Sine4.y, S6.in_w0) annotation (points=[61,-60; 66,-60; 66,-80],
          style(color=74, rgbcolor={0,0,127}));
      connect(Sine3.y, S5.in_w0) annotation (points=[21,-10; 66,-10; 66,-28],
          style(color=74, rgbcolor={0,0,127}));
      connect(S3.flange,LossP1. inlet) 
        annotation (points=[-70,36; -60,36], style(thickness=2, fillPattern=1));
      connect(LossP1.outlet,T1. inlet) annotation (points=[-40,36; -26,36], style(
            thickness=2));
      connect(T1.outlet,FlowSplit1. in1) annotation (points=[-14,36; 0,36], style(
            thickness=2));
      connect(T2.outlet,S1. flange) annotation (points=[36,62; 60,62], style(
            thickness=2));
      connect(T3.outlet,S2. flange) annotation (points=[36,10; 60,10], style(
            thickness=2));
      connect(P2.flange,LossP1. outlet) 
        annotation (points=[-40,54; -40,36]);
      connect(T2.inlet, FlowSplit1.out1) 
        annotation (points=[24,62; 24,62; 12,40.2], style(thickness=2));
      connect(T3.inlet, FlowSplit1.out2) 
        annotation (points=[24,10; 24,10; 12,32], style(thickness=2));
      connect(Sine2.y, S2.in_w0) annotation (points=[61,36; 66,36; 66,16], style(
            color=74, rgbcolor={0,0,127}));
      connect(Sine1.y, S1.in_w0) annotation (points=[21,86; 66,86; 66,68], style(
            color=74, rgbcolor={0,0,127}));
    end TestSplitRev;
    
    model TestValves "Test cases for valves" 
      ThermoPower.Water.SourceP SourceP1(p0=10e5) 
        annotation (extent=[-100,40; -80,60]);
      ThermoPower.Water.SourceP SourceP2(p0=8e5) 
        annotation (extent=[-100,-60; -80,-40]);
      ThermoPower.Water.SinkP SinkP1(p0=1e5) 
        annotation (extent=[70,-10; 90,10]);
      ThermoPower.Water.ValveLiq V1(
        dpnom=9e5,
        wnom=1.5,
      redeclare package Medium = Modelica.Media.Water.StandardWater,
        pnom=10e5,
        Kv=2,
        CvData=ThermoPower.Choices.Valve.CvTypes.Kv) 
                  annotation (extent=[-30,60; -10,80]);
      ThermoPower.Water.ValveLiq V2(
        dpnom=5e5,
        wnom=1.2,
        pnom=10e5,
      redeclare package Medium = Modelica.Media.Water.StandardWater,
        Av=5e-5,
        CvData=ThermoPower.Choices.Valve.CvTypes.Av) 
                  annotation (extent=[-30,20; -10,40]);
      ThermoPower.Water.ValveLiq V3(
        dpnom=3e5,
        wnom=1.1,
        pnom=10e5,
      redeclare package Medium = Modelica.Media.Water.StandardWater,
        Av=5e-5,
        CvData=ThermoPower.Choices.Valve.CvTypes.Av) 
                  annotation (extent=[-30,-40; -10,-20]);
      ThermoPower.Water.ValveLiq V4(
        dpnom=8e5,
        wnom=1.3,
        pnom=10e5,
      redeclare package Medium = Modelica.Media.Water.StandardWater,
        Cv=2,
        CvData=ThermoPower.Choices.Valve.CvTypes.Cv) 
                  annotation (extent=[-30,-80; -10,-60]);
      ThermoPower.Water.ValveLiq V5(
        dpnom=4e5,
        wnom=2,
        pnom=5e5,
      redeclare package Medium = Modelica.Media.Water.StandardWater,
        Av=1e-4,
        CvData=ThermoPower.Choices.Valve.CvTypes.Av) 
                  annotation (extent=[40,-10; 60,10]);
      ThermoPower.Water.FlowSplit FlowSplit1 
        annotation (extent=[-70,40; -50,60]);
      annotation (
        Diagram,
        experiment(StopTime=4, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>This model tests the <tt>ValveLiq</tt> model zero or reverse flow conditions.
<p>Simulate the model for 4 s. At t = 1 s the V5 valve closes in 1 s, the V2 and V3 valves close in 2 s and the V1 and V4 valves open in 2 s. The flow in valve V3 reverses between t = 1.83 and t = 1.93.
</HTML>", revisions="<html>
<ul>
<li><i>18 Nov 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       Parameters updated.</li>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       First release.</li>
</ul>
</html>"));
      ThermoPower.Water.SinkP SinkP2(p0=1e5) 
        annotation (extent=[10,60; 30,80]);
      ThermoPower.Water.FlowJoin FlowJoin1 annotation (extent=[10,-10; 30,10]);
      ThermoPower.Water.FlowSplit FlowSplit2 
        annotation (extent=[-70,-60; -50,-40]);
      ThermoPower.Water.SinkP SinkP3(p0=1e5) 
        annotation (extent=[10,-80; 30,-60]);
      Modelica.Blocks.Sources.Ramp CloseLoad(
        duration=1,
        height=-0.99,
        offset=1,
        startTime=1)    annotation (extent=[20,20; 40,40]);
      Modelica.Blocks.Sources.Ramp OpenRelief(
        duration=2,
        height=1,
        offset=0,
        startTime=1) 
                    annotation (extent=[-92, 74; -72, 94]);
      Modelica.Blocks.Sources.Ramp CloseValves(
        duration=2,
        height=-1,
        offset=1,
        startTime=1) 
                    annotation (extent=[-90,-10; -70,10]);
    equation 
      connect(SourceP1.flange, FlowSplit1.in1) 
        annotation (points=[-80,50; -66,50], style(thickness=2));
      connect(FlowSplit1.out1, V1.inlet) 
        annotation (points=[-54,54.2; -30,70], style(thickness=2));
      connect(V1.outlet, SinkP2.flange) annotation (points=[-10,70; 10,70], style(
            thickness=2));
      connect(V2.outlet, FlowJoin1.in1) annotation (points=[-10,30; 14,4], style(
            thickness=2));
      connect(V3.outlet, FlowJoin1.in2) annotation (points=[-10,-30; 14,-4],
          style(thickness=2));
      connect(FlowJoin1.out, V5.inlet) annotation (points=[26,0; 40,0], style(
            thickness=2));
      connect(V5.outlet, SinkP1.flange) annotation (points=[60,0; 70,0], style(
            thickness=2));
      connect(SourceP2.flange, FlowSplit2.in1) 
        annotation (points=[-80,-50; -66,-50], style(thickness=2));
      connect(FlowSplit2.out2, V4.inlet) 
        annotation (points=[-54,-54; -30,-70], style(thickness=2));
      connect(FlowSplit2.out1, V3.inlet) 
        annotation (points=[-54,-45.8; -30,-30], style(thickness=2));
      connect(V4.outlet, SinkP3.flange) annotation (points=[-10,-70; 10,-70],
          style(thickness=2));
      connect(V2.inlet, FlowSplit1.out2) 
        annotation (points=[-30,30; -30,30; -54,46], style(thickness=2));
      connect(CloseValves.y, V3.theta) annotation (points=[-69,0; -20,0; -20,-22],
          style(color=74, rgbcolor={0,0,127}));
      connect(CloseValves.y, V2.theta) annotation (points=[-69,0; -40,0; -40,50;
            -20,50; -20,38], style(color=74, rgbcolor={0,0,127}));
      connect(OpenRelief.y, V1.theta) annotation (points=[-71,84; -20,84; -20,78],
          style(color=74, rgbcolor={0,0,127}));
      connect(V4.theta, OpenRelief.y) annotation (points=[-20,-62; -20,-50; -44,
            -50; -44,84; -71,84], style(color=74, rgbcolor={0,0,127}));
      connect(CloseLoad.y, V5.theta) annotation (points=[41,30; 50,30; 50,8],
          style(color=74, rgbcolor={0,0,127}));
    end TestValves;
    
    model TestValveChoked "Test case for valves in choked flow" 
      ThermoPower.Water.SourceP SourceP1(p0=5e5, h=400e3) 
        annotation (extent=[-50,30; -30,50]);
      ThermoPower.Water.SinkP SinkP1 
        annotation (extent=[40,30; 60,50]);
      annotation (
        Diagram,
        experiment(StopTime=4, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>This model tests the transition from normal to choked flow for the <tt>ValveLiq</tt> and <tt>ValveVap</tt> models.
<p>Simulate the model for 4 s and observe the flowrate through the two valves. 
</HTML>", revisions="<html>
<ul>
<li><i>18 Nov 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       Parameters updated.</li>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       First release.</li>
</ul>

</html>"));
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[-40,60; -20,80]);
      ThermoPower.Water.ValveLiqChoked ValveLiqChocked(
        dpnom=2e5,
        wnom=1,
        redeclare package Medium = Modelica.Media.Water.StandardWater,
        Av=5e-5,
        CheckValve=false,
        pnom=5e5,
        CvData=ThermoPower.Choices.Valve.CvTypes.Av) 
                          annotation (extent=[-10,30; 10,50]);
      Modelica.Blocks.Sources.Sine Sine1(
        amplitude=2.5e5,
        freqHz=0.5,
        offset=3e5,
        phase=3.14159,
        startTime=1)  annotation (extent=[10,60; 30,80]);
      ThermoPower.Water.SourceP SourceP2(p0=60e5, h=2.9e6) 
        annotation (extent=[-50,-50; -30,-30]);
      ThermoPower.Water.SinkP SinkP2(p0=1e5) 
        annotation (extent=[40,-50; 60,-30]);
      ThermoPower.Water.ValveVap ValveVap(
        dpnom=30e5,
        pnom=60e5,
        wnom=1,
      redeclare package Medium = Modelica.Media.Water.StandardWater,
        Av=1e-4,
        CheckValve=false,
        CvData=ThermoPower.Choices.Valve.CvTypes.Av) 
                  annotation (extent=[-10,-50; 10,-30]);
      Modelica.Blocks.Sources.Constant Constant2 
        annotation (extent=[-40,-20; -20,0]);
      Modelica.Blocks.Sources.Sine Sine2(
        amplitude=49.5e5,
        freqHz=0.5,
        offset=50e5,
        phase=3.14159,
        startTime=1)  annotation (extent=[10,-20; 30,0]);
    equation 
      connect(ValveLiqChocked.outlet, SinkP1.flange) 
        annotation (points=[10,40; 40,40], style(thickness=2));
      connect(SourceP1.flange, ValveLiqChocked.inlet) 
        annotation (points=[-30,40; -10,40], style(thickness=2));
      connect(SourceP2.flange, ValveVap.inlet) 
        annotation (points=[-30,-40; -10,-40], style(thickness=2));
      connect(ValveVap.outlet, SinkP2.flange) 
        annotation (points=[10,-40; 40,-40], style(thickness=2));
      connect(Constant1.y, ValveLiqChocked.theta) annotation (points=[-19,70; 0,
            70; 0,48], style(color=74, rgbcolor={0,0,127}));
      connect(Sine1.y, SinkP1.in_p0) annotation (points=[31,70; 46,70; 46,48.8],
          style(color=74, rgbcolor={0,0,127}));
      connect(Constant2.y, ValveVap.theta) annotation (points=[-19,-10; 0,-10; 0,
            -32], style(color=74, rgbcolor={0,0,127}));
      connect(Sine2.y, SinkP2.in_p0) annotation (points=[31,-10; 46,-10; 46,-31.2],
          style(color=74, rgbcolor={0,0,127}));
    end TestValveChoked;
    
    model TestCoeffValve "Test case for valve with the several coefficients" 
      ThermoPower.Water.SourceP SourceP1(p0=5e5, h=2e5) 
        annotation (extent=[-50,50; -30,70]);
      ThermoPower.Water.SinkP SinkP1(p0=3e5) 
        annotation (extent=[40,50; 60,70]);
      annotation (
        Diagram,
        experiment(StopTime=4, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>This model tests the <tt>ValveLiq</tt> models with four possible flow coefficients (also applies to other valves).
<ol>
<li>Av (metric) flow coefficient [m2];
<li>Kv (metric) flow coefficient [m3/h];
<li>Cv (US) flow coefficient [USG/min];
<li>Av defined by nominal operating point [m2].
</ol>
<p>Simulate the model for 4 s and observe the flowrate through the valves. 
</HTML>", revisions="<html>
<ul>
<li><i>3 Dec 2008</i>
     by <a>Luca Savoldelli</a>:<br>
       First release.</li>
</ul>
</html>"));
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[-90,10; -70,30]);
      Water.ValveLiq ValveLiq1(
        dpnom=2e5,
        wnom=1,
        redeclare package Medium = Modelica.Media.Water.StandardWater,
        pnom=5e5,
        CvData=ThermoPower.Choices.Valve.CvTypes.Av,
        Av=7.2e-5)        annotation (extent=[-10,50; 10,70]);
      ThermoPower.Water.SourceP SourceP2(p0=5e5, h=2e5) 
        annotation (extent=[-50,10; -30,30]);
      ThermoPower.Water.SinkP SinkP2(p0=3e5) 
        annotation (extent=[40,10; 60,30]);
      Water.ValveLiq ValveLiq2(
        dpnom=2e5,
        wnom=1,
        redeclare package Medium = Modelica.Media.Water.StandardWater,
        pnom=5e5,
        CvData=ThermoPower.Choices.Valve.CvTypes.Kv,
        Kv=2.592)         annotation (extent=[-10,10; 10,30]);
      ThermoPower.Water.SourceP SourceP3(p0=5e5, h=2e5) 
        annotation (extent=[-50,-30; -30,-10]);
      ThermoPower.Water.SinkP SinkP3(p0=3e5) 
        annotation (extent=[40,-30; 60,-10]);
      Water.ValveLiq ValveLiq3(
        dpnom=2e5,
        wnom=1,
        redeclare package Medium = Modelica.Media.Water.StandardWater,
        pnom=5e5,
        CvData=ThermoPower.Choices.Valve.CvTypes.Cv,
        Cv=2.997)         annotation (extent=[-10,-30; 10,-10]);
      ThermoPower.Water.SourceP SourceP4(p0=5e5, h=2e5) 
        annotation (extent=[-50,-70; -30,-50]);
      ThermoPower.Water.SinkP SinkP4(p0=3e5) 
        annotation (extent=[40,-70; 60,-50]);
      Water.ValveLiq ValveLiq4(
        dpnom=2e5,
        redeclare package Medium = Modelica.Media.Water.StandardWater,
        pnom=5e5,
        CvData=ThermoPower.Choices.Valve.CvTypes.OpPoint,
        wnom=1.012,
        rhonom=989)       annotation (extent=[-10,-70; 10,-50]);
    equation 
      connect(ValveLiq1.outlet, SinkP1.flange) 
        annotation (points=[10,60; 40,60], style(thickness=2));
      connect(SourceP1.flange, ValveLiq1.inlet) 
        annotation (points=[-30,60; -10,60], style(thickness=2));
      connect(Constant1.y, ValveLiq1.theta) annotation (points=[-69,20; -60,20;
            -60,80; 0,80; 0,68], style(color=74, rgbcolor={0,0,127}));
      connect(ValveLiq2.outlet, SinkP2.flange) 
        annotation (points=[10,20; 40,20], style(thickness=2));
      connect(SourceP2.flange, ValveLiq2.inlet) 
        annotation (points=[-30,20; -10,20], style(thickness=2));
      connect(Constant1.y, ValveLiq2.theta) annotation (points=[-69,20; -60,20;
            -60,40; 0,40; 0,28], style(color=74, rgbcolor={0,0,127}));
      connect(ValveLiq3.outlet, SinkP3.flange) 
        annotation (points=[10,-20; 40,-20], style(thickness=2));
      connect(SourceP3.flange, ValveLiq3.inlet) 
        annotation (points=[-30,-20; -10,-20], style(thickness=2));
      connect(Constant1.y, ValveLiq3.theta) annotation (points=[-69,20; -60,20;
            -60,0; 0,0; 0,-12], style(color=74, rgbcolor={0,0,127}));
      connect(ValveLiq4.outlet, SinkP4.flange) 
        annotation (points=[10,-60; 40,-60], style(thickness=2));
      connect(SourceP4.flange, ValveLiq4.inlet) 
        annotation (points=[-30,-60; -10,-60], style(thickness=2));
      connect(Constant1.y, ValveLiq4.theta) annotation (points=[-69,20; -60,20;
            -60,-40; 0,-40; 0,-52], style(color=74, rgbcolor={0,0,127}));
    end TestCoeffValve;
    
    model ValveZeroFlow "Test case for valves with zero flowrate" 
      ThermoPower.Water.SourceP Source(p0=5e5) 
        annotation (extent=[-90,-10; -70,10]);
      ThermoPower.Water.SinkP Sink(p0=1e5) annotation (extent=[70,-10; 90,10]);
      ThermoPower.Water.ValveLiq V1(
        dpnom=2e5,
        wnom=1,
      redeclare package Medium = Modelica.Media.Water.StandardWater,
        pnom=5e5,
        Av=1e-4,
        CvData=ThermoPower.Choices.Valve.CvTypes.OpPoint) 
                  annotation (extent=[-50,-10; -30,10]);
      ThermoPower.Water.ValveLiq V2(
        dpnom=1e5,
        wnom=1,
      redeclare package Medium = Modelica.Media.Water.StandardWater,
        pnom=3e5,
        Av=1e-4,
        CvData=ThermoPower.Choices.Valve.CvTypes.OpPoint) 
                  annotation (extent=[-10,-10; 10,10]);
      annotation (
        Diagram,
        experiment(StopTime=1, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>This model tests the <tt>ValveLiq</tt> model in zero flowrate conditions.</p>
<p>The flow coefficients are determined by initial equations, assuming a flow rate of 1 kg/s and equal sizing for the three valves.
<p>Simulate the model for 1 s and observe the flowrates through the valves and the inlet and outlet pressure of V2.
</HTML>", revisions="<html>
<ul>
<li><i>18 Nov 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       Parameters updated.</li>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       First release.</li>
</ul>
</html>"));
      Modelica.Blocks.Sources.Step Cmd1(
        height=0,
        offset=1,
        startTime=0)   annotation (extent=[-70,20; -50,40]);
      Modelica.Blocks.Sources.Step Cmd2(
        height=-.5,
        offset=1,
        startTime=0.3)   annotation (extent=[-30,20; -10,40]);
      ThermoPower.Water.ValveLiq V3(
        dpnom=1e5,
        wnom=1,
      redeclare package Medium = Modelica.Media.Water.StandardWater,
        pnom=2e5,
        Av=1e-4,
        CvData=ThermoPower.Choices.Valve.CvTypes.OpPoint) 
                  annotation (extent=[30,-10; 50,10]);
      Modelica.Blocks.Sources.Step Cmd3(
        height=-1,
        offset=1,
        startTime=0.6)   annotation (extent=[10,20; 30,40]);
    equation 
      connect(Source.flange, V1.inlet) annotation (points=[-70,0; -50,0], style(
            thickness=2));
      connect(V1.outlet, V2.inlet) annotation (points=[-30,0; -10,0], style(
            thickness=2));
      connect(V2.outlet, V3.inlet) annotation (points=[10,0; 30,0], style(
            thickness=2));
      connect(Sink.flange, V3.outlet) annotation (points=[70,0; 50,0], style(
            thickness=2));
      connect(Cmd1.y, V1.theta) annotation (points=[-49,30; -40,30; -40,8], style(
            color=74, rgbcolor={0,0,127}));
      connect(Cmd2.y, V2.theta) annotation (points=[-9,30; 0,30; 0,8], style(
            color=74, rgbcolor={0,0,127}));
      connect(Cmd3.y, V3.theta) annotation (points=[31,30; 40,30; 40,8], style(
            color=74, rgbcolor={0,0,127}));
    end ValveZeroFlow;
    
    model ValveZeroFlow2 "Test case for valves with zero flowrate" 
      Modelica.Blocks.Sources.Step Cmd1(
        height=0,
        offset=1,
        startTime=0)   annotation (extent=[-40,20; -20,40]);
      ThermoPower.Water.Tank Tank1(A=0.1,
      redeclare package Medium = Modelica.Media.Water.StandardWater) 
        annotation (extent=[-50,-14; -30,6]);
      ThermoPower.Water.Tank Tank2(A=0.1,
      redeclare package Medium = Modelica.Media.Water.StandardWater) 
                                          annotation (extent=[30,-14; 50,6]);
      ThermoPower.Water.ValveLiq Valve(
        dpnom=1e4,
        wnom=10,
      redeclare package Medium = Modelica.Media.Water.StandardWater,
        Av=3.5e-3,
        pnom=1e5,
        CvData=ThermoPower.Choices.Valve.CvTypes.Av) 
                  annotation (extent=[-10,-20; 10,0]);
      annotation (
        Diagram,
        experiment(StopTime=20, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>This model tests the <tt>ValveLiq</tt> model with small or zero flow and the <tt>Tank</tt> model.</p>
<p>Simulate for 20 s. After 10 s the flowrate goes to zero, as the two levels become equal. </p>
</HTML>", revisions="<html>
<ul>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       First release.</li>
</ul>

</html>"));
      ThermoPower.Water.SourceW SourceW1(w0=0) 
        annotation (extent=[-90,-20; -70,0]);
      ThermoPower.Water.SinkW SinkW1(w0=0) annotation (extent=[70,-20; 90,0]);
    equation 
      connect(Tank1.outlet, Valve.inlet) annotation (points=[-32,-10; -10,-10],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Valve.outlet, Tank2.inlet) annotation (points=[10,-10; 32,-10],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Tank2.outlet, SinkW1.flange) annotation (points=[48,-10; 70,-10],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SourceW1.flange, Tank1.inlet) 
        annotation (points=[-70,-10; -48,-10], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
    initial equation 
      Tank1.y = 2;
      Tank2.y = 1;
    equation 
      connect(Cmd1.y, Valve.theta) annotation (points=[-19,30; 0,30; 0,-2], style(
            color=74, rgbcolor={0,0,127}));
    end ValveZeroFlow2;
    
    model WaterPump "Test case for WaterPump" 
      
      annotation (
        Diagram,
        experiment(StopTime=10, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>This model tests the <tt>Pump</tt> model with the check valve option active. Two pumps in parallel are simulated.
<p>The valve is opened at time t=1s. The sink pressure is then increased so as to operate the pump in all the possible working conditions, including stopped flow.
<p>
Simulation Interval = [0...10] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</HTML>",   revisions="<html>
<ul>
<li><i>30 Jul 2007</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       Updated.</li>
<li><i>5 Nov 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       Updated.</li>
<li><i>5 Feb 2004</i>
    by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco
Schiavo</a>:<br>
       First release.</li>
</ul>

</html>"));
      ThermoPower.Water.SourceP Source(p0=1e5, h=1.5e5) 
        annotation (extent=[-80,-20; -60,0]);
      ThermoPower.Water.ValveLin ValveLin1(Kv=1e-5) 
        annotation (extent=[10,-20; 30,0]);
      ThermoPower.Water.SinkP SinkP1(p0=3e5) 
        annotation (extent=[50,-20; 70,0]);
    /*
  ThermoPower.Water.Pump Pump1(
    rho0=1000,
    pin_start=1e5,
    pout_start=4e5,
    hstart=1e5,
    ThermalCapacity=true,
    V=0.01,
    P_cons={800,1800,2000},
    head_nom={60,30,0},
    q_nom={0,0.001,0.0015},
  redeclare package Medium = Modelica.Media.Water.StandardWater,
  redeclare package SatMedium = Modelica.Media.Water.StandardWater,
    ComputeNPSHa=true,
    CheckValve=true,
    initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                        annotation (extent=[-54,26; -34,46]);
*/
      Water.PumpNPSH Pump1(
        rho0=1000,
        pin_start=1e5,
        pout_start=4e5,
        hstart=1e5,
        V=0.01,
        redeclare package Medium = Modelica.Media.Water.StandardWater,
        CheckValve=true,
        initOpt=ThermoPower.Choices.Init.Options.noInit,
        Np0=2,
        usePowerCharacteristic=true,
        n0=1500,
        redeclare function flowCharacteristic = 
            ThermoPower.Functions.PumpCharacteristics.quadraticFlow (q_nom={0,
                0.001,0.0015}, head_nom={60,30,0}),
        redeclare function powerCharacteristic = 
            ThermoPower.Functions.PumpCharacteristics.quadraticPower (q_nom={0,
                0.001,0.0015}, W_nom={350,500,600})) 
                            annotation (extent=[-40,-22; -20,-2]);
      
      Modelica.Blocks.Sources.Ramp Ramp1(
        duration=4,
        startTime=4,
        height=6e5,
        offset=1e5)  annotation (extent=[20,40; 40,60]);
      Modelica.Blocks.Sources.Ramp Step1(
        height=1,
        startTime=1,
        offset=1e-6,
        duration=1)  annotation (extent=[-20,10; 0,30]);
    equation 
      connect(ValveLin1.outlet, SinkP1.flange) 
        annotation (points=[30,-10; 50,-10], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Source.flange, Pump1.infl) 
        annotation (points=[-60,-10; -38,-10], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Pump1.outfl, ValveLin1.inlet) 
        annotation (points=[-24,-5; -8,-5; -8,-10; 10,-10],     style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Ramp1.y, SinkP1.in_p0) annotation (points=[41,50; 56,50; 56,-1.2],
          style(color=74, rgbcolor={0,0,127}));
      connect(Step1.y, ValveLin1.cmd) annotation (points=[1,20; 20,20; 20,-2],
                           style(color=74, rgbcolor={0,0,127}));
    end WaterPump;
    
    model WaterPumps "Test case for WaterPump" 
      
      annotation (
        Diagram,
        experiment(StopTime=10, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>This model tests three <tt>Pump</tt> models with different flow caratteristcs and with the check valve option active. Two pumps in parallel are simulated.
<p>The valve is opened at time t=1s. The sink pressure is then increased so as to operate the pump in all the possible working conditions, including stopped flow.
<p>
Simulation Interval = [0...10] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</HTML>",   revisions="<html>
<ul>
<li><i>3 Dec 2008</i>
    by <a>Luca Savoldelli</a>:<br>
       First release.</li>
</ul>
</html>"));
      ThermoPower.Water.SourceP Source1(p0=1e5, h=1.5e5) 
        annotation (extent=[-80,40; -60,60]);
      ThermoPower.Water.ValveLin ValveLin1(Kv=1e-5) 
        annotation (extent=[10,40; 30,60]);
      ThermoPower.Water.SinkP SinkP1(p0=3e5) 
        annotation (extent=[50,40; 70,60]);
      Water.PumpNPSH Pump1(
        rho0=1000,
        pin_start=1e5,
        pout_start=4e5,
        hstart=1e5,
        V=0.01,
        redeclare package Medium = Modelica.Media.Water.StandardWater,
        CheckValve=true,
        initOpt=ThermoPower.Choices.Init.Options.noInit,
        Np0=2,
        usePowerCharacteristic=true,
        n0=1500,
        redeclare function flowCharacteristic = 
            ThermoPower.Functions.PumpCharacteristics.linearFlow (q_nom={0.001,
                0.0015}, head_nom={30,0})) 
                            annotation (extent=[-40,38; -20,58]);
      Modelica.Blocks.Sources.Ramp Ramp1(
        duration=4,
        startTime=4,
        height=6e5,
        offset=1e5)  annotation (extent=[20,74; 40,94]);
      Modelica.Blocks.Sources.Ramp Step1(
        height=1,
        startTime=1,
        offset=1e-6,
        duration=1)  annotation (extent=[-20,60; 0,80]);
      ThermoPower.Water.SourceP Source2(
                                       p0=1e5, h=1.5e5) 
        annotation (extent=[-80,-10; -60,10]);
      ThermoPower.Water.ValveLin ValveLin2(Kv=1e-5) 
        annotation (extent=[10,-10; 30,10]);
      ThermoPower.Water.SinkP SinkP2(p0=3e5) 
        annotation (extent=[50,-10; 70,10]);
      Water.PumpNPSH Pump2(
        rho0=1000,
        pin_start=1e5,
        pout_start=4e5,
        hstart=1e5,
        V=0.01,
        redeclare package Medium = Modelica.Media.Water.StandardWater,
        CheckValve=true,
        initOpt=ThermoPower.Choices.Init.Options.noInit,
        Np0=2,
        usePowerCharacteristic=true,
        n0=1500,
        redeclare function flowCharacteristic = 
            ThermoPower.Functions.PumpCharacteristics.quadraticFlow (q_nom={
                0.0005,0.001,0.0015}, head_nom={50,30,0})) 
                            annotation (extent=[-40,-12; -20,8]);
      ThermoPower.Water.SourceP Source3(
                                       p0=1e5, h=1.5e5) 
        annotation (extent=[-80,-60; -60,-40]);
      ThermoPower.Water.ValveLin ValveLin3(Kv=1e-5) 
        annotation (extent=[10,-60; 30,-40]);
      ThermoPower.Water.SinkP SinkP3(p0=3e5) 
        annotation (extent=[50,-60; 70,-40]);
      Water.PumpNPSH Pump3(
        rho0=1000,
        pin_start=1e5,
        pout_start=4e5,
        hstart=1e5,
        V=0.01,
        redeclare package Medium = Modelica.Media.Water.StandardWater,
        CheckValve=true,
        initOpt=ThermoPower.Choices.Init.Options.noInit,
        Np0=2,
        usePowerCharacteristic=true,
        n0=1500,
        redeclare function flowCharacteristic = 
            ThermoPower.Functions.PumpCharacteristics.polynomialFlow (q_nom={
                0.0005,0.001,0.0015}, head_nom={50,30,0})) 
                            annotation (extent=[-40,-62; -20,-42]);
    equation 
      connect(ValveLin1.outlet, SinkP1.flange) 
        annotation (points=[30,50; 50,50],   style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Source1.flange, Pump1.infl) 
        annotation (points=[-60,50; -38,50],   style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Pump1.outfl, ValveLin1.inlet) 
        annotation (points=[-24,55; -8,55; -8,50; 10,50],       style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Ramp1.y, SinkP1.in_p0) annotation (points=[41,84; 56,84; 56,58.8],
          style(color=74, rgbcolor={0,0,127}));
      connect(Step1.y, ValveLin1.cmd) annotation (points=[1,70; 20,70; 20,58],
                           style(color=74, rgbcolor={0,0,127}));
      connect(ValveLin2.outlet,SinkP2. flange) 
        annotation (points=[30,0; 50,0],     style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Source2.flange, Pump2.infl) 
        annotation (points=[-60,0; -38,0],     style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Pump2.outfl,ValveLin2. inlet) 
        annotation (points=[-24,5; -8,5; -8,0; 10,0],           style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(ValveLin3.outlet,SinkP3. flange) 
        annotation (points=[30,-50; 50,-50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Source3.flange, Pump3.infl) 
        annotation (points=[-60,-50; -38,-50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Pump3.outfl,ValveLin3. inlet) 
        annotation (points=[-24,-45; -8,-45; -8,-50; 10,-50],   style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(ValveLin2.cmd, Step1.y) annotation (points=[20,8; 20,20; 6,20; 6,70;
            1,70], style(color=74, rgbcolor={0,0,127}));
      connect(SinkP2.in_p0, Ramp1.y) annotation (points=[56,8.8; 56,20; 46,20; 46,
            84; 41,84], style(color=74, rgbcolor={0,0,127}));
      connect(SinkP3.in_p0, Ramp1.y) annotation (points=[56,-41.2; 56,-30; 46,-30;
            46,84; 41,84], style(color=74, rgbcolor={0,0,127}));
      connect(ValveLin3.cmd, Step1.y) annotation (points=[20,-42; 20,-30; 6,-30;
            6,70; 1,70], style(color=74, rgbcolor={0,0,127}));
    end WaterPumps;
    
    model WaterPumpMech "Test case for WaterPumpMech" 
      annotation (
        Diagram,
        experiment(StopTime=25, Tolerance=1e-006),
        Documentation(info="<html>
<p>The model is designed to test the component <tt>PumpMech</tt>. The simple model of a DC motor <tt>Test.SimpleMotor</tt> is also used.<br>
The simulation starts with a stopped motor and a closed valve.
<ul>
    <li>t=2 s: The voltage supplied is increased up to 380V in 5 s.
    <li>t=15 s, The valve is opened in 5 s. 
</ul>
<p>
Simulation Interval = [0...25] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</html>
",   revisions="<html>
<ul>
<li><i>5 Nov 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       Updated.</li>
        <li><i>5 Feb 2004</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br>
        First release.</li>
</ul>
</html>"));
      package Medium=Modelica.Media.Water.WaterIF97_ph;
      ThermoPower.Water.PumpMech Pump(
        rho0=1000,
        n0=100,
        pin_start=1e5,
        pout_start=4e5,
        V=0.001,
      redeclare package Medium = Modelica.Media.Water.StandardWater,
        initOpt=ThermoPower.Choices.Init.Options.noInit,
        redeclare function flowCharacteristic = 
            ThermoPower.Functions.PumpCharacteristics.quadraticFlow (q_nom={0,0.001,
                0.0015}, head_nom={60,30,0}),
        usePowerCharacteristic=true,
        redeclare function powerCharacteristic = 
            ThermoPower.Functions.PumpCharacteristics.quadraticPower (q_nom={0,
                0.001,0.0015}, W_nom={350,500,600})) 
                              annotation (extent=[-40,-2; -20,18]);
      ThermoPower.Water.SourceP Source annotation (extent=[-80,0; -60,20]);
      ThermoPower.Water.ValveLin Valve(Kv=1e-5) 
        annotation (extent=[20,0; 40,20]);
      Modelica.Blocks.Sources.Ramp Ramp1(
        duration=5,
        height=1,
        offset=0,
        startTime=15)   annotation (extent=[-20,40; 0,60]);
      ThermoPower.Water.SinkP Sink(p0=0.8e5) 
        annotation (extent=[60,0; 80,20]);
      Modelica.Blocks.Sources.Ramp Ramp2(
        duration=5,
        height=380,
        startTime=2,
        offset=0.01)  annotation (extent=[-80,-40; -60,-20]);
      SimpleMotor SimpleMotor1(
        Rm=20,
        Lm=0.1,
        kT=35,
        Jm=10,
        dm=1) annotation (extent=[-40,-40; -20,-20]);
    equation 
      connect(Source.flange, Pump.infl) 
        annotation (points=[-60,10; -38,10], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Pump.outfl, Valve.inlet) 
        annotation (points=[-24,15; 5.9,15; 5.9,10; 20,10], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Valve.outlet, Sink.flange) annotation (points=[40,10; 60,10], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SimpleMotor1.flange_b, Pump.MechPort) annotation (points=[-19.2,-30;
            -10,-30; -10,10.1; -20.9,10.1], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Ramp1.y, Valve.cmd) annotation (points=[1,50; 30,50; 30,18], style(
            color=74, rgbcolor={0,0,127}));
      connect(Ramp2.y, SimpleMotor1.inPort) annotation (points=[-59,-30; -39.9,
            -30], style(color=74, rgbcolor={0,0,127}));
    end WaterPumpMech;
    
    model SimpleMotor 
      "A simple model of an electrical dc motor (based on DriveLib model)." 
      parameter Modelica.SIunits.Resistance Rm=10 "Motor Resistance";
      parameter Modelica.SIunits.Inductance Lm=1 "Motor Inductance";
      parameter Real kT=1 "Torque Constant";
      parameter Modelica.SIunits.Inertia Jm=10 "Motor Inertia";
      parameter Real dm(
        final unit="N.m.s/rad",
        final min=0) = 0 "Damping constant";
      Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm n;
      Modelica.Electrical.Analog.Sources.SignalVoltage Vs 
        annotation (extent=[-80, 10; -60, -10], rotation=90);
      Modelica.Electrical.Analog.Basic.Ground G 
        annotation (extent=[-80, -60; -60, -40]);
      Modelica.Electrical.Analog.Basic.Resistor R(R=Rm) 
        annotation (extent=[-60, 30; -40, 50]);
      Modelica.Electrical.Analog.Basic.Inductor L(L=Lm) 
        annotation (extent=[-20, 30; 0, 50]);
      Modelica.Electrical.Analog.Basic.EMF emf(k=kT) 
        annotation (extent=[0, -10; 20, 10]);
      Modelica.Blocks.Interfaces.RealInput inPort 
        annotation (extent=[-108,-10; -90,10]);
      Modelica.Mechanics.Rotational.Inertia J(J=Jm) 
        annotation (extent=[48, -10; 68, 10]);
      Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b 
        annotation (extent=[96, -12; 120, 12]);
      Modelica.Mechanics.Rotational.Fixed Fixed 
        annotation (extent=[26, -52; 46, -32]);
      Modelica.Mechanics.Rotational.Damper Damper(d=dm) 
        annotation (extent=[26, -32; 46, -12], rotation=90);
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]),
        Window(
          x=0.15,
          y=0.18,
          width=0.45,
          height=0.58),
        Icon(
          Rectangle(extent=[60, 6; 96, -6], style(color=9, fillColor=9)),
          Rectangle(extent=[-60, 40; 60, -40], style(gradient=2, fillColor=74)),
          Rectangle(extent=[-80, -80; 80, -100], style(pattern=0, fillColor=0)),
          Line(points=[-90, 0; -60, 0]),
          Text(extent=[-80, 100; 80, 60], string="%name"),
          Polygon(points=[-60, -80; -40, -20; 40, -20; 60, -80; 60, -80; -60, -80],
               style(
              pattern=0,
              gradient=1,
              fillColor=0))),
        Documentation(info="<HTML>
<p>This is a basic model of an electrical DC motor used to drive a pump in <tt>WaterPumpMech</tt>.
</HTML>",   revisions="<html>
<ul>
<li><i>5 Feb 2004</i>
    by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco
Schiavo</a>:<br>
       First release.</li>
</ul>
</html>"),
        DymolaStoredErrors,
        Diagram);
    equation 
      n = Modelica.SIunits.Conversions.to_rpm(J.w);
      connect(R.n, L.p) annotation (points=[-40, 40; -20, 40]);
      connect(L.n, emf.p) annotation (points=[0, 40; 10, 40; 10, 10]);
      connect(emf.flange_b, J.flange_a) annotation (points=[20, 0; 48, 0]);
      connect(R.p, Vs.p) annotation (points=[-60, 40; -70, 40; -70, 10]);
      connect(Vs.n, emf.n) 
        annotation (points=[-70, -10; -70, -20; 10, -20; 10, -10]);
      connect(G.p, Vs.n) annotation (points=[-70, -40; -70, -10]);
      connect(J.flange_b, flange_b) annotation (points=[68, 0; 108, 0]);
      connect(inPort,Vs.v) 
        annotation (points=[-99,0; -77,-4.28612e-016]);
      connect(Fixed.flange_b, Damper.flange_a) 
        annotation (points=[36, -42; 36, -32], style(color=0));
      connect(Damper.flange_b, J.flange_a) 
        annotation (points=[36, -12; 36, 0; 48, 0], style(color=0));
    end SimpleMotor;
    
    model TestAccumulator "Simple test for Water-Gas Accumulator component" 
      package Medium=Modelica.Media.Water.WaterIF97_ph;
      ThermoPower.Water.Accumulator Accumulator1(
        hl_start=1e5,
        Tg_start=300,
        Tgin=300,
        Tg0=300,
        pg0=5e5,
        V=5,
        Vl0=3,
        zl0=2,
        zl_start=0,
        pg_start=7e5,
        gamma_ex=100,
        wg_out0=2e-2,
        MM=29e-3,
        A=1,
      redeclare package Medium = Modelica.Media.Water.StandardWater,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
             annotation (extent=[-10,-82; 30,-42]);
      ThermoPower.Water.SourceW SourceW1(w0=0) 
        annotation (extent=[-38,-90; -18,-70]);
      ThermoPower.Water.SinkP SinkP1(p0=1e5) 
        annotation (extent=[70,-90; 90,-70]);
      ThermoPower.Water.PressDropLin PressDropLin1(R=1e5) 
        annotation (extent=[38,-90; 58,-70]);
      annotation (
        Diagram,
        experiment(StopTime=8000, Tolerance=1e-006),
        Documentation(info="<html>
<p>The model is designed to test the component  <tt>Accumulator</tt>.<br>
Simulation sequence:
<ul>
    <li>t=500 s: The accumulator is charged for 20 s.
    <li>t=2500 s, The accumulator is discharged for 20 s. 
    <li>t=8000 s, 10% increase of the inlet flowrate
</ul>
<p>
Simulation Interval = [0...8000] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</html>",   revisions="<html>
<ul>
        <li><i>5 Feb 2004</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br> 
        First release.</li>
</ul>
</html>"));
      Modelica.Blocks.Sources.Step Step1(height=2e-2, startTime=500) 
        annotation (extent=[-90,0; -70,20]);
      Modelica.Blocks.Math.Add Add1 annotation (extent=[-40,-20; -20,0]);
      Modelica.Blocks.Sources.Step Step2(height=-2e-2, startTime=520) 
        annotation (extent=[-90,-40; -70,-20]);
      Modelica.Blocks.Sources.Step Step3(height=1, startTime=2500) 
        annotation (extent=[-90,70; -70,90]);
      Modelica.Blocks.Math.Add Add2 annotation (extent=[-40,50; -20,70]);
      Modelica.Blocks.Sources.Step Step5(height=-1, startTime=2520) 
        annotation (extent=[-90,30; -70,50]);
      Modelica.Blocks.Sources.Step Step4(
        height=0.5,
        offset=5,
        startTime=5000) 
                      annotation (extent=[-60,-60; -40,-40]);
    equation 
      connect(Accumulator1.WaterOutfl, PressDropLin1.inlet) 
        annotation (points=[16.8,-80; 38,-80], style(thickness=2));
      connect(PressDropLin1.outlet, SinkP1.flange) 
        annotation (points=[58,-80; 70,-80], style(thickness=2));
      connect(SourceW1.flange, Accumulator1.WaterInfl) 
        annotation (points=[-18,-80; 3.2,-80], style(thickness=2));
    initial equation 
    /*
  der(Accumulator1.rhog) = 0;
  der(Accumulator1.Tg) = 0;
  der(Accumulator1.hl) = 0;
  Accumulator1.zl = 0;
*/
    equation 
      connect(Add1.y, Accumulator1.GasInfl) annotation (points=[-19,-10; -14,
            -10; -14,-44; -4.8,-44],
                                style(color=74, rgbcolor={0,0,127}));
      connect(Add2.y, Accumulator1.OutletValveOpening) annotation (points=[-19,60;
            18.8,60; 18.8,-44], style(color=74, rgbcolor={0,0,127}));
      connect(Step4.y, SourceW1.in_w0) annotation (points=[-39,-50; -32,-50; -32,
            -74], style(color=74, rgbcolor={0,0,127}));
      connect(Step5.y, Add2.u2) annotation (points=[-69,40; -42,54], style(color=
              74, rgbcolor={0,0,127}));
      connect(Step3.y, Add2.u1) annotation (points=[-69,80; -42,66], style(color=
              74, rgbcolor={0,0,127}));
      connect(Step1.y, Add1.u1) annotation (points=[-69,10; -42,-4], style(color=
              74, rgbcolor={0,0,127}));
      connect(Step2.y, Add1.u2) annotation (points=[-69,-30; -42,-16], style(
            color=74, rgbcolor={0,0,127}));
    end TestAccumulator;
    
    model TestST1 
      package Medium=Modelica.Media.Water.StandardWater;
      parameter MassFlowRate w=1;
      parameter Pressure pin=60e5;
      parameter Pressure pcond=0.08e5;
      parameter PerUnit eta_iso=0.92;
      parameter PerUnit eta_mech=0.98;
      parameter AngularVelocity omega=314;
      parameter SpecificEnthalpy hin=2.949e6;
      parameter SpecificEnthalpy hout_iso=2.240e6;
      parameter SpecificEnthalpy hout=hin-eta_iso*(hin-hout_iso);
      parameter Power Pnet=eta_iso*eta_mech*w*(hin-hout_iso);
      parameter Torque tau=0.8*Pnet/omega;
      parameter Time Ta=10 "Turbine acceleration time";
      parameter MomentOfInertia J=Pnet*Ta/omega^2;
      parameter HydraulicResistance Kv=1/2e5;
      parameter PerUnit theta0(fixed=false)=1;
      
      Water.SteamTurbineUnit ST(
        hpFraction=0.63,
        T_HP=0.2,
        T_LP=3.4,
        hstartin=2.9e6,
        hstartout=2.24e6,
        pnom=pin,
        wnom=w,
        pstartin=pin,
        eta_iso=eta_iso,
        redeclare package Medium=Medium) 
                         annotation (extent=[-20,-20; 20,20]);
      Water.SourceP SourceP1(p0=pin, h=hin) 
        annotation (extent=[-100,4; -80,24]);
      annotation (Diagram, uses(Modelica(version="1.6")),
        experiment(
          StopTime=5,
          fixedstepsize=1e-005,
          Algorithm=""),
        experimentSetupOutput,
        Documentation(info="<html>
<p>This model is designed to test the <tt>SteamTurbineUnit</tt> component when connected to an inertial load. Simulation sequence:
<ul>
    <li>t=0 s: The system starts at equilibrium
    <li>t=1 s: The throttle valve opening is reduced.
    <li>t=5 s: After 4 s the turbine speed has lost rad/s.
</ul>
<p>
Simulation Interval = [0...5] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-4 
</p>
</html>", revisions="<html>
<ul>
        <li><i>21 Jul 2004</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br> 
        First release.</li>
</ul>
</html>
"));
      Modelica.Mechanics.Rotational.Inertia Inertia1(J=J) 
        annotation (extent=[30,-10; 50,10]);
      Water.SinkP SinkP1(p0=pcond) 
        annotation (extent=[60,-40; 80,-20]);
      Water.ValveLin ValveLin1(Kv=Kv) 
        annotation (extent=[-70,4; -50,24]);
      Modelica.Blocks.Sources.Step Step1(
        height=-0.01,
        offset=theta0,
        startTime=1)     annotation (extent=[-90,40; -70,60]);
      Modelica.Mechanics.Rotational.Torque Load 
        annotation (extent=[80,-10; 60,10]);
      Modelica.Blocks.Sources.Constant TorqueLoad(k=-tau) 
        annotation (extent=[60,20; 80,40]);
      Water.SensT SensT1(redeclare package Medium=Medium) 
                         annotation (extent=[-46,8; -26,28]);
    equation 
      connect(ST.shaft_b, Inertia1.flange_a) 
        annotation (points=[19.8,3.55271e-016; 18,3.55271e-016; 18,0; 30,0],
          style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(ST.outlet, SinkP1.flange) 
        annotation (points=[20,-14; 20,-30; 60,-30], style(thickness=2));
      connect(SourceP1.flange, ValveLin1.inlet) 
        annotation (points=[-80,14; -70,14], style(thickness=2));
      connect(Inertia1.flange_b, Load.flange_b) 
        annotation (points=[50,0; 60,0], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
    initial equation 
      ST.phi=0;
      ST.omega=omega;
      der(ST.omega)=0;
      der(ST.P_HP)=0;
      der(ST.P_LP)=0;
    equation 
      connect(ValveLin1.outlet, SensT1.inlet) 
        annotation (points=[-50,14; -42,14], style(thickness=2));
      connect(SensT1.outlet, ST.inlet) 
        annotation (points=[-30,14; -20,14], style(thickness=2));
      connect(Step1.y, ValveLin1.cmd) annotation (points=[-69,50; -60,50; -60,22],
          style(color=74, rgbcolor={0,0,127}));
      connect(TorqueLoad.y, Load.tau) annotation (points=[81,30; 94,30; 94,0; 82,
            0], style(color=74, rgbcolor={0,0,127}));
    end TestST1;
    
    model TestST2 
      package Medium=Modelica.Media.Water.StandardWater;
      parameter MassFlowRate w=1;
      parameter Pressure pin=60e5;
      parameter Pressure pcond=0.08e5;
      parameter PerUnit eta_iso=0.92;
      parameter PerUnit eta_mech=0.98;
      parameter AngularVelocity omega=314;
      parameter SpecificEnthalpy hin=2.949e6;
      parameter SpecificEnthalpy hout_iso=2.240e6;
      parameter SpecificEnthalpy hout=hin-eta_iso*(hin-hout_iso);
      parameter Power Pnet=eta_iso*eta_mech*w*(hin-hout_iso);
      parameter Torque tau=0.8*Pnet/omega;
      parameter Time Ta=10 "Turbine acceleration time";
      parameter MomentOfInertia J=Pnet*Ta/omega^2;
      parameter HydraulicResistance Kv=1/2e5;
      parameter PerUnit theta0=0.3;
      
      Water.SteamTurbineUnit ST(
        hpFraction=0.63,
        T_HP=0.2,
        T_LP=3.4,
        hstartin=2.9e6,
        hstartout=2.8e6,
        pnom=pin,
        wnom=w,
        pstartin=pin,
        eta_iso=eta_iso,
        redeclare package Medium=Medium) 
                         annotation (extent=[-20,-20; 20,20]);
      Water.SourceP SourceP1(         p0=pin, h=hin) 
        annotation (extent=[-96,4; -76,24]);
      annotation (Diagram, uses(Modelica(version="1.6")),
        experiment(
          StopTime=10,
          fixedstepsize=1e-005,
          Algorithm=""),
        experimentSetupOutput,
        Documentation(info="<html>
<p>This model is designed to test the <tt>SteamTurbineUnit</tt> component when connected to a fixed speed load. Simulation sequence:
<ul>
    <li>t=0 s: The system starts at equilibrium
    <li>t=1 s: The throttle valve opening is reduced.
    <li>t=10 s: After 9 s the torque applied to the load has been reduced by 6%.
</ul>
<p>
Simulation Interval = [0...10] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-4 
</p>
</html>", revisions="<html>
<ul>
        <li><i>21 Jul 2004</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br> 
        First release.</li>
</ul>
</html>
"));
      Modelica.Mechanics.Rotational.Inertia Inertia1(J=J) 
        annotation (extent=[30,-10; 50,10]);
      Water.SinkP SinkP1(p0=pcond) 
        annotation (extent=[60,-60; 80,-40]);
      Water.ValveLin ValveLin1(Kv=Kv) 
        annotation (extent=[-60,4; -40,24]);
      Modelica.Blocks.Sources.Step Step1(
        height=-0.1,
        offset=theta0,
        startTime=1)     annotation (extent=[-80,40; -60,60]);
      Modelica.Mechanics.Rotational.Speed Speed1(exact=true) 
        annotation (extent=[80,-10; 60,10]);
      Modelica.Blocks.Sources.Constant Constant1(k=omega) 
        annotation (extent=[60,20; 80,40]);
    equation 
      connect(ST.shaft_b, Inertia1.flange_a) 
        annotation (points=[19.8,3.55271e-016; 18,3.55271e-016; 18,0; 30,0],
          style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(ST.outlet, SinkP1.flange) 
        annotation (points=[20,-14; 20,-50; 60,-50], style(thickness=2));
      connect(ValveLin1.outlet, ST.inlet) 
        annotation (points=[-40,14; -20,14], style(thickness=2));
      connect(SourceP1.flange, ValveLin1.inlet) 
        annotation (points=[-76,14; -60,14], style(thickness=2));
    initial equation 
      ST.phi=0;
      der(ST.P_HP)=0;
      der(ST.P_LP)=0;
    equation 
      connect(Speed1.flange_b, Inertia1.flange_b) 
        annotation (points=[60,0; 50,0], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Step1.y, ValveLin1.cmd) annotation (points=[-59,50; -50,50; -50,22],
          style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, Speed1.w_ref) annotation (points=[81,30; 90,30; 90,0;
            82,0], style(color=74, rgbcolor={0,0,127}));
    end TestST2;
  end WaterElements;
  
  package ThermalElements 
    "Test for Thermal package elements and Flow1D models of Water and Gas packages" 
    
    model TestConvHT2N 
      parameter Integer Nbig = 6;
      parameter Integer Nsmall = 3;
      Thermal.ConvHT2N HTa(
        gamma=100,
        N1=Nbig,
        N2=Nsmall) annotation (extent=[-60,-12; -20,28]);
      Thermal.TempSource1Dlin T1a(N=Nbig) 
                                       annotation (extent=[-60,16; -20,56]);
      annotation (Diagram, Documentation(info="<html>
<p>This model is designed to test the <tt>ConvHT2N</tt> model.
<p> HTa tests the case with a bigger number of nodes on side1, HTb the case with an equal number of nodes on both sides, and HTc the case with a smaller number of nodes on side 1. It is possible to change <tt>Nbig</tt> and <tt>Nsmall</tt> to any value.
</html>",   revisions="<html>
<ul>
        <li><i>12 May 2005</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
        First release.</li>
</ul>
</html>

"));
      Thermal.TempSource1Dlin T2a(N=Nsmall) 
                                       annotation (extent=[-60,0; -20,-40]);
      Modelica.Blocks.Sources.Constant Constant1(k=300) 
        annotation (extent=[-92,50; -72,70]);
      Modelica.Blocks.Sources.Constant Constant2(k=400) 
        annotation (extent=[-64,70; -44,90]);
      Modelica.Blocks.Sources.Constant Constant3(k=280) 
        annotation (extent=[-92,-60; -72,-40]);
      Modelica.Blocks.Sources.Constant Constant4(k=350) 
        annotation (extent=[-66,-80; -46,-60]);
      Thermal.ConvHT2N HTb(
        gamma=100,
        N1=Nsmall,
        N2=Nsmall) annotation (extent=[-16,-12; 24,28]);
      Thermal.TempSource1Dlin T1b(N=Nsmall) 
                                       annotation (extent=[-16,16; 24,56]);
      Thermal.TempSource1Dlin T2b(N=Nsmall) 
                                       annotation (extent=[-16,0; 24,-40]);
      Thermal.ConvHT2N HTc(
        gamma=100,
        N1=Nsmall,
        N2=Nbig)   annotation (extent=[30,-12; 70,28]);
      Thermal.TempSource1Dlin T1c(N=Nsmall) 
                                       annotation (extent=[30,16; 70,56]);
      Thermal.TempSource1Dlin T2c(N=Nbig) 
                                       annotation (extent=[30,0; 70,-40]);
    equation 
      connect(T1a.wall, HTa.side1)      annotation (points=[-40,30; -40,14],
          style(color=45, rgbcolor={255,127,0}));
      connect(HTa.side2, T2a.wall)      annotation (points=[-40,1.8; -40,-14],
          style(color=45, rgbcolor={255,127,0}));
      connect(Constant1.y, T1a.temperature_node1) 
                                                 annotation (points=[-71,60; -48,
            60; -48,42], style(color=74, rgbcolor={0,0,127}));
      connect(Constant2.y, T1a.temperature_nodeN) 
                                                 annotation (points=[-43,80; -32,
            80; -32,41.6], style(color=74, rgbcolor={0,0,127}));
      connect(Constant3.y, T2a.temperature_node1) 
                                                 annotation (points=[-71,-50; -48,
            -50; -48,-26], style(color=74, rgbcolor={0,0,127}));
      connect(Constant4.y, T2a.temperature_nodeN) 
                                                 annotation (points=[-45,-70; -32,
            -70; -32,-25.6], style(color=74, rgbcolor={0,0,127}));
      connect(T1b.wall, HTb.side1)      annotation (points=[4,30; 4,14],
          style(color=45, rgbcolor={255,127,0}));
      connect(HTb.side2, T2b.wall)      annotation (points=[4,1.8; 4,-14],
          style(color=45, rgbcolor={255,127,0}));
      connect(T1c.wall, HTc.side1)      annotation (points=[50,30; 50,14],
          style(color=45, rgbcolor={255,127,0}));
      connect(HTc.side2, T2c.wall)      annotation (points=[50,1.8; 50,-14],
          style(color=45, rgbcolor={255,127,0}));
      connect(Constant3.y, T2b.temperature_node1) annotation (points=[-71,-50; -4,
            -50; -4,-26], style(color=74, rgbcolor={0,0,127}));
      connect(Constant3.y, T2c.temperature_node1) annotation (points=[-71,-50; 42,
            -50; 42,-26], style(color=74, rgbcolor={0,0,127}));
      connect(Constant4.y, T2b.temperature_nodeN) annotation (points=[-45,-70; 12,
            -70; 12,-25.6], style(color=74, rgbcolor={0,0,127}));
      connect(Constant4.y, T2c.temperature_nodeN) annotation (points=[-45,-70; 58,
            -70; 58,-25.6], style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, T1b.temperature_node1) annotation (points=[-71,60; -4,
            60; -4,42], style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, T1c.temperature_node1) annotation (points=[-71,60; 42,
            60; 42,42], style(color=74, rgbcolor={0,0,127}));
      connect(Constant2.y, T1b.temperature_nodeN) annotation (points=[-43,80; 12,
            80; 12,41.6], style(color=74, rgbcolor={0,0,127}));
      connect(Constant2.y, T1c.temperature_nodeN) annotation (points=[-43,80; 58,
            80; 58,41.6], style(color=74, rgbcolor={0,0,127}));
    end TestConvHT2N;
    
    model TestFlow1Da "Test case for Flow1D" 
      package Medium=Modelica.Media.Water.WaterIF97_ph;
      // number of Nodes
      parameter Integer Nnodes=20;
      // total length
      parameter Modelica.SIunits.Length Lhex=10;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dihex=0.02;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dihex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dihex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2;
      // friction coefficient
      parameter Real Cfhex=0.005;
      // nominal (and initial) mass flow rate
      parameter Modelica.SIunits.MassFlowRate whex=0.31;
      // initial pressure
      parameter Modelica.SIunits.Pressure phex=2e5;
      // initial inlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy hinhex=1e5;
      // initial outlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy houthex=1e5;
      
      //height of enthalpy step 
      parameter Modelica.SIunits.SpecificEnthalpy deltah=41800;
      
      //height of power step
      parameter Modelica.SIunits.EnergyFlowRate W=41800*whex;
      
      // transport time delay
      Time tau;
      ThermoPower.Water.SourceW Fluid_Source(
        p0=phex,
        h=hinhex,
        w0=whex) annotation (extent=[-78,-10; -58,10]);
      ThermoPower.Water.SinkP Fluid_Sink(p0=phex/2) 
        annotation (extent=[70,-10; 90,10]);
      ThermoPower.Water.ValveLin Valve(Kv=3e-6) 
        annotation (extent=[10,-10; 30,10]);
      ThermoPower.Water.Flow1D hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        DynamicMomentum=false,
        hstartin=hinhex,
        hstartout=houthex,
        pstartin=phex,
        pstartout=phex,
      redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[-20,-10; 0,10]);
      annotation (
        Diagram,
        experiment(StopTime=80, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D</tt> (fluid side of a heat exchanger, finite volumes).<br>
This model represent the fluid side of a heat exchanger with an applied external heat flow. The operating fluid is liquid water.<br> 
During the simulation, the inlet specific enthalpy, heat flux and mass flow rate are changed:
<ul>
    <li>t=0 s, Step variation of the specific enthalpy of the fluid entering the heat exchanger. The outlet temperature should undergo a step change 10 s later.</li>
    <li>t=30 s, Step variation of the thermal flow entering the heat exchanger lateral surface. The outlet temperature should undergo a ramp change lasting 10 s</li> 
    <li>t=50 s, Step variation of the mass flow rate entering the heat exchanger. Again, the outlet temperature should undergo a ramp change lasting 10s</li> 
</ul>
<p>
Simulation Interval = [0...80] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br> 
    First release.</li>
</ul>
</html>"));
      ThermoPower.Water.SensT T_in(
      redeclare package Medium = Medium) 
                                   annotation (extent=[-50,-6; -30,14]);
      ThermoPower.Thermal.HeatSource1D HeatSource1D1(
        N=Nnodes,
        L=Lhex,
        omega=omegahex) annotation (extent=[-20, 22; 0, 42]);
      Modelica.Blocks.Sources.Step MassFlowRate(
        height=-0.02,
        offset=whex,
        startTime=50)   annotation (extent=[-98,28; -78,48]);
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[-10,60; 10,80],  rotation=0);
      Modelica.Blocks.Sources.Step InSpecEnthalpy(height=deltah, offset=hinhex,
        startTime=1) annotation (extent=[-90,60; -70,80]);
      Modelica.Blocks.Sources.Step ExtPower(height=W, startTime=30) 
        annotation (extent=[-40,40; -20,60]);
      ThermoPower.Water.SensT T_out(
      redeclare package Medium = Medium) 
                                    annotation (extent=[40,-6; 60,14]);
    equation 
      tau = sum(hex.rho)/Nnodes*Lhex*Ahex/whex;
      connect(hex.outfl, Valve.inlet) annotation (points=[0,0; 10,0], style(
            thickness=2));
      connect(T_in.outlet, hex.infl) annotation (points=[-34,0; -20,0], style(
            thickness=2));
      connect(Fluid_Source.flange, T_in.inlet) 
        annotation (points=[-58,0; -46,0], style(thickness=2));
      connect(HeatSource1D1.wall, hex.wall) 
        annotation (points=[-10,29; -10,5],    style(color=45));
      connect(T_out.outlet, Fluid_Sink.flange) 
        annotation (points=[56,0; 70,0], style(thickness=2));
      connect(Valve.outlet, T_out.inlet) annotation (points=[30,0; 44,0], style(
            thickness=2));
      connect(MassFlowRate.y, Fluid_Source.in_w0) annotation (points=[-77,38; -72,
            38; -72,6], style(color=74, rgbcolor={0,0,127}));
      connect(InSpecEnthalpy.y, Fluid_Source.in_h) annotation (points=[-69,70;
            -64,70; -64,6], style(color=74, rgbcolor={0,0,127}));
      connect(ExtPower.y, HeatSource1D1.power) annotation (points=[-19,50; -10,50;
            -10,36], style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, Valve.cmd) annotation (points=[11,70; 20,70; 20,8],
          style(color=74, rgbcolor={0,0,127}));
    end TestFlow1Da;
    
    model TestFlow1Db "Test case for Flow1D" 
      package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      // number of Nodes
      parameter Integer Nnodes=20;
      // total length
      parameter Modelica.SIunits.Length Lhex=200;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dihex=0.02;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dihex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dihex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2;
      // friction coefficient
      parameter Real Cfhex=0.005;
      // nominal (and initial) mass flow rate
      parameter Modelica.SIunits.MassFlowRate whex=0.31;
      // initial pressure
      parameter Modelica.SIunits.Pressure phex=3e5;
      // initial inlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy hs=1e5;
      ThermoPower.Water.Flow1D hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        HydraulicCapacitance=2,
        hstartin=hs,
        hstartout=hs,
        pstartin=phex,
        pstartout=phex,
      redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[-26,-10; -6,10]);
      ThermoPower.Thermal.TempSource1D TempSource(N=Nnodes) 
        annotation (extent=[-26,40; -6,60]);
      annotation (
        Diagram,
        experiment(StopTime=200, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D</tt> (fluid side of a heat exchanger, finite volumes). <br>
This model represent the fluid side of a heat exchanger with convective exchange with an external source of given temperature. The operating fluid is liquid water.<br> 
During experiment the external (fixed) temperature changes: 
<ul>
    <li>t=20 s, Step variation of the external temperature. Heat exchanger outlet temperature should vary accordingly to the transfer function (K1/(1+s*tau1))*(1-exp(-K2-s*tau2)), where the parameters K1, K2, tau1, tau1 depend on exchanger geometry, the fluid heat transfer coefficient and the operating conditions.</li>
</ul>
</p>
</p>
<p>
Simulation Interval = [0...200] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br> 
    First release.</li>
</ul>
</html>"));
      ThermoPower.Water.ValveLin ValveLin1(Kv=2*whex/phex) 
        annotation (extent=[10,-10; 30,10]);
      ThermoPower.Water.SourceW FluidSource(
        w0=whex,
        p0=phex,
        h=hs) annotation (extent=[-90,-10; -70,10]);
      ThermoPower.Water.SinkP FluidSink(p0=phex/2, h=hs) 
        annotation (extent=[70,-10; 90,10]);
      Modelica.Blocks.Sources.Step Temperature(
        height=10,
        offset=297,
        startTime=20)   annotation (extent=[-60,60; -40,80]);
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[-10,70; 10,90]);
      ThermoPower.Thermal.ConvHT ConvEx(N=Nnodes, gamma=400) 
        annotation (extent=[-26,20; -6,40]);
      ThermoPower.Water.SensT T_in(
      redeclare package Medium = Medium) 
                                   annotation (extent=[-60,-6; -40,14]);
      ThermoPower.Water.SensT T_out(
      redeclare package Medium = Medium) 
                                    annotation (extent=[40,-6; 60,14]);
    equation 
      connect(hex.outfl, ValveLin1.inlet) annotation (points=[-6,0; 10,0], style(
            thickness=2));
      connect(ConvEx.side1, TempSource.wall) 
        annotation (points=[-16,33; -16,47],   style(color=45));
      connect(hex.wall, ConvEx.side2) 
        annotation (points=[-16,5; -16,26.9],    style(color=45));
      connect(T_in.inlet, FluidSource.flange) 
        annotation (points=[-56,0; -70,0], style(thickness=2));
      connect(T_in.outlet, hex.infl) annotation (points=[-44,0; -26,0], style(
            thickness=2));
      connect(ValveLin1.outlet, T_out.inlet) 
        annotation (points=[30,0; 44,0], style(thickness=2));
      connect(T_out.outlet, FluidSink.flange) 
        annotation (points=[56,0; 70,0], style(thickness=2));
      connect(Temperature.y, TempSource.temperature) annotation (points=[-39,70;
            -16,70; -16,54], style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, ValveLin1.cmd) annotation (points=[11,80; 20,80; 20,8],
          style(color=74, rgbcolor={0,0,127}));
    end TestFlow1Db;
    
    model TestFlow1Dc "Test case for Flow1D" 
      package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      // number of Nodes
      parameter Integer Nnodes=20;
      // total length
      parameter Modelica.SIunits.Length Lhex=200;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dihex=0.02;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dihex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dihex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2;
      // friction coefficient
      parameter Real Cfhex=0.005;
      // nominal (and initial) mass flow rate
      parameter Modelica.SIunits.MassFlowRate whex=0.31;
      // initial pressure
      parameter Modelica.SIunits.Pressure phex=1e5;
      // initial specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy hs=1e5;
      ThermoPower.Water.Flow1D hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        HydraulicCapacitance=2,
        hstartin=hs,
        hstartout=hs,
        DynamicMomentum=false,
        pstartin=2*phex,
        pstartout=2*phex,
      redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                       annotation (extent=[-20,-10; 0,10]);
      annotation (
        Diagram,
        experiment(StopTime=1000, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D</tt> (fluid side of a heat exchanger, finite volumes). <br>
This model is designed to simulate the flow reversal througth the heat exchanger. The operating fluid is liquid water; the heat flux entering the heat exchanger is set to zero. <br>
During the simulation, flow reversal is achieved:
<ul>
        <li>t=500 s, Negative ramp variation (duration = 20 s) of the mass flow rate trough the heat exchanger. The final mass flow rate has the same magnitude and opposite direction with respect to the initial one.</li>
</ul>
</p>
<p>
Simulation Interval = [0...1000] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br> 
    First release.</li>
</ul>
</html>"));
      ThermoPower.Water.ValveLin ValveLin1(Kv=2*whex/phex) 
        annotation (extent=[40,-10; 60,10]);
      ThermoPower.Water.SinkP SinkP1(h=hs, p0=4*phex) 
        annotation (extent=[70,-10; 90,10]);
      ThermoPower.Water.SourceW SourceW1(
        w0=whex,
        G=0,
        p0=2*phex,
        h=2*hs) annotation (extent=[-80,-10; -60,10]);
      Modelica.Blocks.Sources.Ramp Ramp1(
        duration=20,
        height=-2*whex,
        offset=whex,
        startTime=500)   annotation (extent=[-100,28; -80,48]);
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[10,50; 30,70]);
      ThermoPower.Thermal.HeatSource1D HeatSource1D1(
        N=Nnodes,
        L=Lhex,
        omega=omegahex) annotation (extent=[-20,20; 0,40]);
      Modelica.Blocks.Sources.Constant Constant2(k=0) 
        annotation (extent=[-50,50; -30,70]);
      ThermoPower.Water.SensT T_in(redeclare package Medium = 
            Medium)                annotation (extent=[-50,-6; -30,14]);
      ThermoPower.Water.SensT T_out(redeclare package Medium = 
            Medium)                 annotation (extent=[10,-6; 30,14]);
    equation 
      connect(ValveLin1.outlet, SinkP1.flange) 
        annotation (points=[60,0; 70,0], style(thickness=2));
      connect(HeatSource1D1.wall, hex.wall) 
        annotation (points=[-10,27; -10,5],    style(color=45));
      connect(SourceW1.flange, T_in.inlet) 
        annotation (points=[-60,0; -46,0], style(thickness=2));
      connect(T_in.outlet, hex.infl) annotation (points=[-34,0; -20,0], style(
            thickness=2));
      connect(T_out.outlet, ValveLin1.inlet) 
        annotation (points=[26,0; 40,0], style(thickness=2));
      connect(hex.outfl, T_out.inlet) annotation (points=[0,0; 14,0], style(
            thickness=2));
      connect(Ramp1.y, SourceW1.in_w0) annotation (points=[-79,38; -74,38; -74,6],
          style(color=74, rgbcolor={0,0,127}));
      connect(Constant2.y, HeatSource1D1.power) annotation (points=[-29,60; -10,
            60; -10,34], style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, ValveLin1.cmd) annotation (points=[31,60; 50,60; 50,8],
          style(color=74, rgbcolor={0,0,127}));
    end TestFlow1Dc;
    
    model TestFlow1Dd "Test case for Flow1D" 
      package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      // number of Nodes
      parameter Integer Nnodes=20;
      // total length
      parameter Modelica.SIunits.Length Lhex=10;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dihex=0.02;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dihex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dihex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2;
      // friction coefficient
      parameter Real Cfhex=0.005;
      // nominal (and initial) mass flow rate
      parameter Modelica.SIunits.MassFlowRate whex=1e-2;
      // initial pressure
      parameter Modelica.SIunits.Pressure phex=0.2e5;
      // initial specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy hs=3e6;
      // Time constant
      Time tau;
      
      ThermoPower.Water.Flow1D hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        HydraulicCapacitance=2,
        pstartin=phex,
        pstartout=phex,
        hstartin=hs,
        hstartout=hs,
        redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                      annotation (extent=[-20,-10; 0,10]);
      ThermoPower.Water.SourceW MassFlowRateSource(
        w0=whex,
        h=hs) annotation (extent=[-60, -10; -40, 10]);
      ThermoPower.Water.SinkP FluidSink(
        p0=0,
        R=100,
        h=3e6) annotation (extent=[70,-10; 90,10]);
      ThermoPower.Water.ValveLin ValveLin1(Kv=1e-7) 
        annotation (extent=[34,-10; 54,10]);
      annotation (
        Diagram,
        experiment(StopTime=2, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D</tt> (fluid side of a heat exchanger, finite volumes).<br>
This model is designed to the test compressibility effects. The operating fluid is superheated vapour; the heat flow entering the heat exchanger is set to zero. <br>
During simulation mass flow rate changes:
<ul>
        <li>t=2 s, Step variation of the inlet mass flow rate. The pressure increases with a first order dynamics, the tube actually behaving like a pressurized tank.</li>
</ul>
</p>
</p>
<p>
Simulation Interval = [0...2] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br> 
    First release.</li>
</ul>
</html>"));
      Modelica.Blocks.Sources.Step MassFlowRateStep(
        height=whex/10,
        offset=whex,
        startTime=0.5)   annotation (extent=[-90,30; -70,50]);
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[8,60; 28,80]);
      ThermoPower.Thermal.HeatSource1D HeatSource1D1(
        N=Nnodes,
        L=Lhex,
        omega=omegahex) annotation (extent=[-20,20; 0,40]);
      Modelica.Blocks.Sources.Constant ExtPower(k=0) 
        annotation (extent=[-50,60; -30,80]);
      Water.SensP SensP annotation (extent=[10,14; 30,34]);
    equation 
      // RC constant of equivalent circuit
      tau = (1/ValveLin1.Kv)*(Ahex*Lhex/1200^2);
      connect(ValveLin1.inlet, hex.outfl) annotation (points=[34,0; 0,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(ValveLin1.outlet, FluidSink.flange) 
        annotation (points=[54,0; 70,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(MassFlowRateSource.flange, hex.infl) 
        annotation (points=[-40,0; -20,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(HeatSource1D1.wall, hex.wall) 
        annotation (points=[-10,27; -10,5],   style(color=45));
    initial equation 
      der(hex.p) = 0;
    equation 
      connect(SensP.flange, ValveLin1.inlet) 
        annotation (points=[20,20; 20,12; 34,12; 34,0]);
      connect(Constant1.y, ValveLin1.cmd) annotation (points=[29,70; 44,70; 44,8],
          style(color=74, rgbcolor={0,0,127}));
      connect(ExtPower.y, HeatSource1D1.power) annotation (points=[-29,70; -10,70;
            -10,34], style(color=74, rgbcolor={0,0,127}));
      connect(MassFlowRateStep.y, MassFlowRateSource.in_w0) annotation (points=[
            -69,40; -54,40; -54,6], style(color=74, rgbcolor={0,0,127}));
    end TestFlow1Dd;
    
    model TestFlow1De "Test case for Flow1D" 
      package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      // number of Nodes
      parameter Integer Nnodes=20;
      // total length
      parameter Modelica.SIunits.Length Lhex=200;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dihex=0.02;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dihex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dihex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2;
      // friction coefficient
      parameter Real Cfhex=0.005;
      // nominal (and initial) mass flow rate
      parameter Modelica.SIunits.MassFlowRate whex=0.31;
      // initial pressure
      parameter Modelica.SIunits.Pressure phex=3e5;
      // initial inlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy hinhex=1e5;
      // initial outlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy houthex=1e5;
      ThermoPower.Water.Flow1D hexA(
        N=Nnodes,
        Nt=1,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        HydraulicCapacitance=2,
        hstartin=hinhex,
        hstartout=houthex,
        pstartin=phex,
        pstartout=phex,
        redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[-20,-70; 0,-50]);
      ThermoPower.Water.SinkP SideA_FluidSink 
        annotation (extent=[70,-70; 90,-50]);
      ThermoPower.Water.SinkP SideB_FluidSink 
        annotation (extent=[-80,30; -100,50]);
      ThermoPower.Water.SourceW SideA_MassFlowRate(
        w0=whex,
        p0=3e5)     annotation (extent=[-74,-70; -54,-50]);
      ThermoPower.Water.ValveLin ValveLin1(Kv=whex/(2e5)) 
        annotation (extent=[14,-70; 34,-50]);
      ThermoPower.Water.ValveLin ValveLin2(Kv=whex/(2e5)) 
        annotation (extent=[-30,30; -50,50]);
      ThermoPower.Water.Flow1D hexB(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        HydraulicCapacitance=2,
        hstartin=hinhex,
        hstartout=houthex,
        pstartin=phex,
        pstartout=phex,
        redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[0,50; -20,30]);
      annotation (
        Diagram,
        experiment(StopTime=900, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D</tt> (fluid side of a heat exchanger, model uses finite volumes).<br>
This model represent the two fluid sides of a heat exchanger in counterflow configuration. The operating fluid is liquid water.<br> 
The mass flow rate during the experiment and initial conditions are the same for the two sides. <br>
During the simulation, the inlet specific enthalpy for hexA (\"hot side\") is changed:
<ul>
    <li>t=50 s, Step variation of the specific enthalpy of the fluid entering hexA .</li>
</ul>
The outlet temperature of the hot side starts changing after the fluid transport time delay, while the outlet temperature of the cold side starts changing immediately.
</p>
</p>
<p>
Simulation Interval = [0...900] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br> 
    First release.</li>
</ul>
</html>"));
      ThermoPower.Water.SensT SensT_A_in(redeclare package Medium = 
            Medium)                      annotation (extent=[-50,-66; -30,-46]);
      Modelica.Blocks.Sources.Step SideA_InSpecEnth(
        height=1e5,
        offset=1e5,
        startTime=50)   annotation (extent=[-90,-20; -70,0]);
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[-70,70; -50,90]);
      Modelica.Blocks.Sources.Constant Constant2 
        annotation (extent=[0,-20; 20,0]);
      ThermoPower.Water.SensT SensT_B_in(redeclare package Medium = 
            Medium)                      annotation (extent=[30,34; 10,54]);
      ThermoPower.Water.SourceW SideB_MassFlowRate(w0=whex, p0=3e5) 
        annotation (extent=[60,30; 40,50]);
      ThermoPower.Thermal.ConvHT ConvExCF(N=Nnodes, gamma=400) 
        annotation (extent=[-20,-40; 0,-20]);
      ThermoPower.Water.SensT SensT_A_out(redeclare package Medium = 
            Medium)                       annotation (extent=[40,-66; 60,-46]);
      ThermoPower.Water.SensT SensT_B_out(redeclare package Medium = 
            Medium)                       annotation (extent=[-54,34; -74,54]);
      Thermal.CounterCurrent CounterCurrent1(N=Nnodes) 
        annotation (extent=[-20,0; 0,20]);
    equation 
      connect(SideA_MassFlowRate.flange, SensT_A_in.inlet) 
        annotation (points=[-54,-60; -46,-60], style(thickness=2));
      connect(SensT_A_in.outlet, hexA.infl) 
        annotation (points=[-34,-60; -20,-60], style(thickness=2));
      connect(hexA.outfl, ValveLin1.inlet) 
        annotation (points=[0,-60; 14,-60], style(thickness=2));
      connect(ValveLin2.inlet, hexB.outfl) 
        annotation (points=[-30,40; -20,40], style(thickness=2));
      connect(SensT_B_in.outlet, hexB.infl) annotation (points=[14,40; 0,40],
          style(thickness=2));
      connect(SideB_MassFlowRate.flange, SensT_B_in.inlet) 
        annotation (points=[40,40; 26,40], style(thickness=2));
      connect(ConvExCF.side2, hexA.wall) 
        annotation (points=[-10,-33.1; -10,-55],style(color=45));
      connect(ValveLin1.outlet, SensT_A_out.inlet) 
        annotation (points=[34,-60; 44,-60], style(thickness=2));
      connect(SensT_A_out.outlet, SideA_FluidSink.flange) 
        annotation (points=[56,-60; 70,-60], style(thickness=2));
      connect(SensT_B_out.outlet, SideB_FluidSink.flange) 
        annotation (points=[-70,40; -80,40]);
      connect(SensT_B_out.inlet, ValveLin2.outlet) 
        annotation (points=[-58,40; -50,40], style(thickness=2));
      connect(ConvExCF.side1, CounterCurrent1.side2) annotation (points=[-10,-27;
            -10,6.9], style(color=45, rgbcolor={255,127,0}));
      connect(CounterCurrent1.side1, hexB.wall) annotation (points=[-10,13; -10,
            35], style(color=45, rgbcolor={255,127,0}));
      connect(SideA_InSpecEnth.y, SideA_MassFlowRate.in_h) annotation (points=[
            -69,-10; -60,-10; -60,-54], style(color=74, rgbcolor={0,0,127}));
      connect(Constant2.y, ValveLin1.cmd) annotation (points=[21,-10; 24,-10; 24,
            -52], style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, ValveLin2.cmd) annotation (points=[-49,80; -40,80; -40,
            48], style(color=74, rgbcolor={0,0,127}));
    end TestFlow1De;
    
    model TestFlow1Df "Test case for Flow1D" 
      package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      // number of Nodes
      parameter Integer Nnodes=20;
      // total length
      parameter Modelica.SIunits.Length Lhex=200;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dihex=0.02;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dihex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dihex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2;
      // friction coefficient
      parameter Real Cfhex=0.005;
      // nominal (and initial) mass flow rate
      parameter Modelica.SIunits.MassFlowRate whex=0.31;
      // initial pressure
      parameter Modelica.SIunits.Pressure phex=3e5;
      // initial inlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy hinhex=1e5;
      // initial outlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy houthex=1e5;
      ThermoPower.Water.Flow1D hexA(
        N=Nnodes,
        Nt=1,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        HydraulicCapacitance=2,
        hstartin=hinhex,
        hstartout=houthex,
        pstartin=phex,
        pstartout=phex,
        redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[-20,-60; 0,-40]);
      ThermoPower.Thermal.ConvHT ConvHTB(N=Nnodes, gamma=400) 
        annotation (extent=[-20,20; 0,40]);
      ThermoPower.Thermal.ConvHT ConvHTA(N=Nnodes, gamma=400) 
        annotation (extent=[-20,-40; 0,-20]);
      ThermoPower.Water.SinkP SideA_FluidSink 
        annotation (extent=[70,-60; 90,-40]);
      ThermoPower.Water.SinkP SideB_FluidSink 
        annotation (extent=[-80,40; -100,60]);
      ThermoPower.Water.SourceW SideA_MassFlowRate(
        w0=whex,
        p0=3e5)     annotation (extent=[-76,-60; -56,-40]);
      ThermoPower.Water.ValveLin ValveLin1(Kv=whex/(2e5)) 
        annotation (extent=[18,-60; 38,-40]);
      ThermoPower.Water.ValveLin ValveLin2(Kv=whex/(2e5)) 
        annotation (extent=[-30,40; -50,60]);
      ThermoPower.Water.Flow1D hexB(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        HydraulicCapacitance=2,
        hstartin=hinhex,
        hstartout=houthex,
        pstartin=phex,
        pstartout=phex,
        redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[0,60; -20,40]);
      ThermoPower.Thermal.MetalTube MetalWall(
        N=Nnodes,
        L=Lhex,
        lambda=20,
        rint=rhex,
        rext=rhex + 1e-3,
        rhomcm=4.9e6,
        Tstart1=297,
        TstartN=297,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[-20,0; 0,-20]);
      annotation (
        Diagram,
        experiment(StopTime=900, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D</tt> (fluid side of a heat exchanger, model uses finite volumes).<br>
This model represent the two fluid sides of a heat exchanger in counterflow configuration. The two sides are divided by a metal wall. The operating fluid is liquid water. The mass flow rate during the experiment and initial conditions are the same for the two sides. <br>
During the simulation, the inlet specific enthalpy for hexA (\"hot side\") is changed:
<ul>
    <li>t=50 s, Step variation of the specific enthalpy of the fluid entering hexA .</li>
</ul>
The outlet temperature of the hot side changes after the fluid transport time delay and the first order delay due to the wall's thermal inertia. The outlet temperature of the cold side starts changing after the thermal inertia delay. </p>
<p>
Simulation Interval = [0...900] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br> 
    First release.</li>
</ul>
</html>"));
      ThermoPower.Water.SensT SensT_A_in(redeclare package Medium = 
            Medium)                      annotation (extent=[-50,-56; -30,-36]);
      Modelica.Blocks.Sources.Step SideA_InSpecEnth(
        height=1e5,
        offset=1e5,
        startTime=50)   annotation (extent=[-90,-20; -70,0]);
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[-72,70; -52,90]);
      Modelica.Blocks.Sources.Constant Constant2 
        annotation (extent=[4,-20; 24,0]);
      ThermoPower.Water.SensT SensT_B_in(redeclare package Medium = 
            Medium)                      annotation (extent=[30,44; 10,64]);
      ThermoPower.Water.SourceW SourceW1(w0=whex, p0=3e5) 
        annotation (extent=[60,40; 40,60]);
      ThermoPower.Water.SensT SensT_A_out(redeclare package Medium = 
            Medium)                       annotation (extent=[44,-56; 64,-36]);
      ThermoPower.Water.SensT SensT_B_out(redeclare package Medium = 
            Medium)                       annotation (extent=[-54,44; -74,64]);
      Thermal.CounterCurrent CounterCurrent1(N=Nnodes) 
        annotation (extent=[-20,0; 0,20]);
    equation 
      connect(SideA_MassFlowRate.flange, SensT_A_in.inlet) 
        annotation (points=[-56,-50; -46,-50], style(thickness=2));
      connect(SensT_A_in.outlet, hexA.infl) 
        annotation (points=[-34,-50; -20,-50], style(thickness=2));
      connect(hexA.outfl, ValveLin1.inlet) 
        annotation (points=[0,-50; 18,-50], style(thickness=2));
      connect(ValveLin2.inlet, hexB.outfl) 
        annotation (points=[-30,50; -20,50], style(thickness=2));
      connect(ConvHTB.side1, hexB.wall) 
        annotation (points=[-10,33; -10,45],   style(color=45));
      connect(hexA.wall, ConvHTA.side2) 
        annotation (points=[-10,-45; -10,-33.1],  style(color=45));
      connect(SensT_B_in.outlet, hexB.infl) annotation (points=[14,50; 0,50],
          style(thickness=2));
      connect(SourceW1.flange, SensT_B_in.inlet) 
        annotation (points=[40,50; 26,50], style(thickness=2));
      connect(MetalWall.int, ConvHTA.side1) 
        annotation (points=[-10,-13; -10,-27],
                                             style(color=45));
      connect(SensT_A_out.inlet, ValveLin1.outlet) 
        annotation (points=[48,-50; 38,-50], style(thickness=2));
      connect(SensT_A_out.outlet, SideA_FluidSink.flange) 
        annotation (points=[60,-50; 70,-50], style(thickness=2));
      connect(SensT_B_out.outlet, SideB_FluidSink.flange) 
        annotation (points=[-70,50; -80,50], style(thickness=2));
      connect(SensT_B_out.inlet, ValveLin2.outlet) 
        annotation (points=[-58,50; -50,50], style(thickness=2));
      connect(ConvHTB.side2, CounterCurrent1.side1) annotation (points=[-10,26.9;
            -10,13], style(color=45, rgbcolor={255,127,0}));
      connect(MetalWall.ext, CounterCurrent1.side2) annotation (points=[-10,-6.9;
            -10,6.9],  style(color=45, rgbcolor={255,127,0}));
      connect(Constant1.y, ValveLin2.cmd) annotation (points=[-51,80; -40,80; -40,
            58], style(color=74, rgbcolor={0,0,127}));
      connect(SideA_InSpecEnth.y, SideA_MassFlowRate.in_h) annotation (points=[
            -69,-10; -62,-10; -62,-44], style(color=74, rgbcolor={0,0,127}));
      connect(Constant2.y, ValveLin1.cmd) annotation (points=[25,-10; 28,-10; 28,
            -42], style(color=74, rgbcolor={0,0,127}));
    end TestFlow1Df;
    
    model TestFlow1DSlowFast "Test case for Flow1D" 
      // package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      package Medium=Media.LiquidWaterConstant;
      
      // number of Nodes
      parameter Integer Nnodes=20;
      // total length
      parameter Modelica.SIunits.Length Lhex=10;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dihex=0.02;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dihex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dihex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2;
      // friction coefficient
      parameter Real Cfhex=0.005;
      // nominal (and initial) mass flow rate
      parameter Modelica.SIunits.MassFlowRate whex=0.31;
      // initial pressure
      parameter Modelica.SIunits.Pressure phex=2e5;
      // initial inlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy hinhex=1e5;
      // initial outlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy houthex=1e5;
      
      //height of enthalpy step 
      parameter Modelica.SIunits.SpecificEnthalpy deltah=41800;
      
      //height of power step
      parameter Modelica.SIunits.EnergyFlowRate W=41800*whex;
      
      // transport time delay
      Time tau;
      ThermoPower.Water.SourceW Fluid_Source(
        p0=phex,
        h=hinhex,
        w0=whex,
        redeclare package Medium = Medium) 
                 annotation (extent=[-76,-10; -56,10]);
      ThermoPower.Water.SinkP Fluid_Sink(p0=phex/2, redeclare package Medium = 
            Medium) 
        annotation (extent=[70,-10; 90,10]);
      ThermoPower.Water.ValveLin Valve(Kv=3e-6, redeclare package Medium = Medium) 
        annotation (extent=[10,-10; 30,10]);
      ThermoPower.Water.Flow1D hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        DynamicMomentum=false,
        hstartin=hinhex,
        hstartout=houthex,
        pstartin=phex,
        pstartout=phex,
        redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.NoFriction,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[-20,-10; 0,10]);
      annotation (
        Diagram,
        experiment(StopTime=80, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D</tt> (fluid side of a heat exchanger, finite volumes).<br>
This model represent the fluid side of a heat exchanger with an applied external heat flow. The operating fluid is liquid water.<p> 
Different media models can be employed; incompressible medium models avoid fast pressure states.<p>
During the simulation, the inlet specific enthalpy, heat flux and mass flow rate are changed:
<ul>
    <li>t=0 s, Step variation of the specific enthalpy of the fluid entering the heat exchanger. The outlet temperature should undergo a step change 10 s later.</li>
    <li>t=30 s, Step variation of the thermal flow entering the heat exchanger lateral surface. The outlet temperature should undergo a ramp change lasting 10 s</li> 
    <li>t=50 s, Step variation of the mass flow rate entering the heat exchanger. Again, the outlet temperature should undergo a ramp change lasting 10s</li> 
</ul>
<p>
Simulation Interval = [0...80] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</HTML>", revisions="<html>
<ul>
    <li><i>24 Sep 2004</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br> 
    Adapted to multiple media models.
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br>
    First release.</li>
</ul>
</html>"));
      ThermoPower.Water.SensT T_in(redeclare package Medium = Medium) 
                                   annotation (extent=[-50,-6; -30,14]);
      ThermoPower.Thermal.HeatSource1D HeatSource1D1(
        N=Nnodes,
        L=Lhex,
        omega=omegahex) annotation (extent=[-20, 22; 0, 42]);
      Modelica.Blocks.Sources.Step MassFlowRate(
        height=-0.02,
        offset=whex,
        startTime=50)   annotation (extent=[-100,20; -80,40]);
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[-10,70; 10,90],  rotation=0);
      Modelica.Blocks.Sources.Step InSpecEnthalpy(height=deltah, offset=hinhex,
        startTime=1) annotation (extent=[-90,50; -70,70]);
      Modelica.Blocks.Sources.Step ExtPower(height=W, startTime=30) 
        annotation (extent=[-40,50; -20,70]);
      ThermoPower.Water.SensT T_out(redeclare package Medium = Medium) 
                                    annotation (extent=[40,-6; 60,14]);
    equation 
      tau = sum(hex.rho)/Nnodes*Lhex*Ahex/whex;
      connect(hex.outfl, Valve.inlet) annotation (points=[0,0; 10,0], style(
            thickness=2));
      connect(T_in.outlet, hex.infl) annotation (points=[-34,0; -20,0], style(
            thickness=2));
      connect(Fluid_Source.flange, T_in.inlet) 
        annotation (points=[-56,0; -46,0], style(thickness=2));
      connect(HeatSource1D1.wall, hex.wall) 
        annotation (points=[-10,29; -10,5],    style(color=45));
      connect(T_out.outlet, Fluid_Sink.flange) 
        annotation (points=[56,0; 70,0], style(thickness=2));
      connect(Valve.outlet, T_out.inlet) annotation (points=[30,0; 44,0], style(
            thickness=2));
      connect(MassFlowRate.y, Fluid_Source.in_w0) annotation (points=[-79,30; -70,
            30; -70,6], style(color=74, rgbcolor={0,0,127}));
      connect(InSpecEnthalpy.y, Fluid_Source.in_h) annotation (points=[-69,60;
            -62,60; -62,6], style(color=74, rgbcolor={0,0,127}));
      connect(ExtPower.y, HeatSource1D1.power) annotation (points=[-19,60; -10,60;
            -10,36], style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, Valve.cmd) annotation (points=[11,80; 20,80; 20,8],
          style(color=74, rgbcolor={0,0,127}));
    end TestFlow1DSlowFast;
    
    model TestFlow1DDB "Test case for Flow1D" 
      package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      // number of Nodes
      parameter Integer Nnodes=20;
      // total length
      parameter Modelica.SIunits.Length Lhex=200;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dihex=0.02;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dihex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dihex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2;
      // friction coefficient
      parameter Real Cfhex=0.005;
      // nominal (and initial) mass flow rate
      parameter Modelica.SIunits.MassFlowRate whex=0.31;
      // initial pressure
      parameter Modelica.SIunits.Pressure phex=3e5;
      // initial inlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy hs=1e5;
      Water.Flow1DDB hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        HydraulicCapacitance=2,
        hstartin=hs,
        hstartout=hs,
        pstartin=phex,
        pstartout=phex,
        redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState)          annotation (extent=[-20,-10;
            0,10]);
      Thermal.TempSource1D TempSource(N=Nnodes) 
        annotation (extent=[-20,40; 0,60]);
      annotation (
        Diagram,
        experiment(StopTime=200, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D</tt> (fluid side of a heat exchanger, finite volumes). <br>
This model represent the fluid side of a heat exchanger with convective exchange with an external source of given temperature. The operating fluid is liquid water.<br> 
During experiment the external (fixed) temperature changes: 
<ul>
    <li>t=20 s, Step variation of the external temperature. Heat exchanger outlet temperature should vary accordingly to the transfer function (K1/(1+s*tau1))*(1-exp(-K2-s*tau2)), where the parameters K1, K2, tau1, tau1 depend on exchanger geometry, the fluid heat transfer coefficient and the operating conditions.</li>
</ul>
</p>
</p>
<p>
Simulation Interval = [0...200] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br> 
    First release.</li>
</ul>
</html>"));
      ThermoPower.Water.ValveLin ValveLin1(Kv=2*whex/phex) 
        annotation (extent=[14,-10; 34,10]);
      ThermoPower.Water.SourceW FluidSource(
        w0=whex,
        p0=phex,
        h=hs) annotation (extent=[-80,-10; -60,10]);
      ThermoPower.Water.SinkP FluidSink(p0=phex/2, h=hs) 
        annotation (extent=[70,-10; 90,10]);
      Modelica.Blocks.Sources.Step Temperature(
        height=10,
        offset=297,
        startTime=20)   annotation (extent=[-50,60; -30,80]);
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[-4,70; 16,90]);
      ThermoPower.Water.SensT T_in(
      redeclare package Medium = Medium) 
                                   annotation (extent=[-50,-6; -30,14]);
      ThermoPower.Water.SensT T_out(
      redeclare package Medium = Medium) 
                                    annotation (extent=[40,-6; 60,14]);
      ThermoPower.Thermal.ConvHT_htc ConvHTe_htc1(N=Nnodes) 
        annotation (extent=[-20,36; 0,16]);
    equation 
      connect(hex.outfl, ValveLin1.inlet) annotation (points=[0,0; 14,0], style(
            thickness=2));
      connect(ValveLin1.outlet, T_out.inlet) 
        annotation (points=[34,0; 44,0], style(thickness=2));
      connect(T_out.outlet, FluidSink.flange) 
        annotation (points=[56,0; 70,0], style(thickness=2));
      connect(ConvHTe_htc1.fluidside, hex.wall) annotation (points=[-10,23; -10,5],
                     style(color=3, rgbcolor={0,0,255}));
      connect(ConvHTe_htc1.otherside, TempSource.wall) annotation (points=[-10,29;
            -10,47],         style(color=45, rgbcolor={255,127,0}));
      connect(Temperature.y, TempSource.temperature) annotation (points=[-29,70;
            -10,70; -10,54], style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, ValveLin1.cmd) annotation (points=[17,80; 24,80; 24,8],
          style(color=74, rgbcolor={0,0,127}));
      connect(FluidSource.flange, T_in.inlet) 
        annotation (points=[-60,0; -46,0], style(thickness=2));
      connect(T_in.outlet, hex.infl) 
        annotation (points=[-34,0; -20,0], style(thickness=2));
    end TestFlow1DDB;
    
    model TestFlow1DfemA "Test case for Flow1Dfem" 
      package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      // number of Nodes
      parameter Integer Nnodes=20;
      // total length
      parameter Modelica.SIunits.Length Lhex=10;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dihex=0.02;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dihex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dihex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2;
      // friction coefficient
      parameter Real Cfhex=0.005;
      // nominal (and initial) mass flow rate
      parameter Modelica.SIunits.MassFlowRate whex=0.3;
      // initial pressure
      parameter Modelica.SIunits.Pressure phex=2e5;
      // initial inlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy hinhex=1e5;
      // initial outlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy houthex=1e5;
      
      //height of enthalpy step 
      parameter Modelica.SIunits.SpecificEnthalpy deltah=41800;
      
      //height of power step
      parameter Modelica.SIunits.EnergyFlowRate W=41800*whex;
      
      ThermoPower.Water.SourceW Fluid_Source(
        p0=phex,
        h=hinhex,
        w0=whex) annotation (extent=[-76,-10; -56,10]);
      ThermoPower.Water.SinkP Fluid_Sink(p0=phex/2) 
        annotation (extent=[64,-10; 84,10]);
      ThermoPower.Water.ValveLin Valve(Kv=3e-6) 
        annotation (extent=[12,-10; 32,10]);
      ThermoPower.Water.Flow1Dfem hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        DynamicMomentum=false,
        hstartin=hinhex,
        hstartout=houthex,
        pstartin=phex,
        pstartout=phex,
      redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[-20,-10; 0,10]);
      annotation (
        Diagram,
        experiment(StopTime=80, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1Dfem</tt> (fluid side of a heat exchanger, finite element method).<br>
This model represent the fluid side of a heat exchanger with an applied external heat flow. The operating fluid is liquid water.<br> 
During the simulation, the inlet specific enthalpy, heat flux and mass flow rate are changed:
<ul>
    <li>t=0 s, Step variation of the specific enthalpy of the fluid entering the heat exchanger. The outlet temperature should undergo a step change 10 s later.</li>
    <li>t=30 s, Step variation of the thermal flow entering the heat exchanger lateral surface. The outlet temperature should undergo a ramp change lasting 10 s</li> 
    <li>t=50 s, Step variation of the mass flow rate entering the heat exchanger. Again, the outlet temperature should undergo a ramp change lasting 10s</li> 
</ul>
<p>
Simulation Interval = [0...80] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br> 
    First release.</li>
</ul>
</html>"));
      ThermoPower.Water.SensT T_in(
      redeclare package Medium = Medium) 
                                   annotation (extent=[-48,-6; -28,14]);
      ThermoPower.Thermal.HeatSource1D HeatSource1D1(
        N=Nnodes,
        L=Lhex,
        omega=omegahex) annotation (extent=[-20, 22; 0, 42]);
      Modelica.Blocks.Sources.Step MassFlowRate(
        height=-0.02,
        offset=whex,
        startTime=50)   annotation (extent=[-94,20; -74,40]);
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[-10,60; 10,80],  rotation=0);
      Modelica.Blocks.Sources.Step InSpecEnthalpy(height=deltah, offset=hinhex,
        startTime=1) annotation (extent=[-94,50; -74,70]);
      Modelica.Blocks.Sources.Step ExtPower(height=W, startTime=30) 
        annotation (extent=[-40,40; -20,60]);
      ThermoPower.Water.SensT T_out(
      redeclare package Medium = Medium) 
                                    annotation (extent=[38,-6; 58,14]);
    equation 
      connect(hex.outfl, Valve.inlet) annotation (points=[0,0; 12,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(T_in.outlet, hex.infl) annotation (points=[-32,0; -20,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Fluid_Source.flange, T_in.inlet) 
        annotation (points=[-56,0; -44,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(HeatSource1D1.wall, hex.wall) 
        annotation (points=[-10,29; -10,5],    style(color=45));
      connect(T_out.outlet, Fluid_Sink.flange) 
        annotation (points=[54,0; 64,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Valve.outlet, T_out.inlet) annotation (points=[32,0; 42,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(MassFlowRate.y, Fluid_Source.in_w0) annotation (points=[-73,30; -70,
            30; -70,6], style(color=74, rgbcolor={0,0,127}));
      connect(InSpecEnthalpy.y, Fluid_Source.in_h) annotation (points=[-73,60;
            -62,60; -62,6], style(color=74, rgbcolor={0,0,127}));
      connect(ExtPower.y, HeatSource1D1.power) annotation (points=[-19,50; -10,50;
            -10,36], style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, Valve.cmd) annotation (points=[11,70; 22,70; 22,8],
          style(color=74, rgbcolor={0,0,127}));
    end TestFlow1DfemA;
    
    model TestFlow1DfemB "Test case for Flow1Dfem" 
      package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      // number of Nodes
      parameter Integer Nnodes=20;
      // total length
      parameter Modelica.SIunits.Length Lhex=200;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dihex=0.02;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dihex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dihex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2;
      // friction coefficient
      parameter Real Cfhex=0.005;
      // nominal (and initial) mass flow rate
      parameter Modelica.SIunits.MassFlowRate whex=0.31;
      // initial pressure
      parameter Modelica.SIunits.Pressure phex=3e5;
      // initial inlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy hs=1e5;
      ThermoPower.Water.Flow1Dfem hex(
        redeclare package Medium=Medium,
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        HydraulicCapacitance=2,
        hstartin=hs,
        hstartout=hs,
        pstartin=phex,
        pstartout=phex,
        alpha=1,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                 annotation (extent=[-20,-10; 0,10]);
      ThermoPower.Thermal.TempSource1D TempSource(N=Nnodes) 
        annotation (extent=[-20,30; 0,50]);
      annotation (
        Diagram,
        experiment(StopTime=200, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1Dfem</tt> (fluid side of a heat exchanger, finite element method). <br>
This model represent the fluid side of a heat exchanger with convective exchange with an external source at a given temperature.<br>
The operating fluid is liquid water.<br> 
During the experiment the external (fixed) temperature changes: 
<ul>
        <li>t=20 s, Step variation of the external temperature. Heat exchanger outlet temperature should vary accordingly to the transfer function (K1/(1+s*tau1))*(1-exp(-K2-s*tau2)), where the parameters K1, K2, tau1, tau1 depend on exchanger geometry, the fluid heat transfer coefficient and operating conditions.</li>
</ul>
</p>
</p>
<p>
Simulation Interval = [0...200] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br> 
    First release.</li>
</ul>
</html>"));
      ThermoPower.Water.ValveLin ValveLin1(Kv=2*whex/phex) 
        annotation (extent=[10,-10; 30,10]);
      ThermoPower.Water.SourceW FluidSource(
        w0=whex,
        p0=phex,
        h=hs) annotation (extent=[-80,-10; -60,10]);
      ThermoPower.Water.SinkP FluidSink(p0=phex/2, h=hs) 
        annotation (extent=[70,-10; 90,10]);
      Modelica.Blocks.Sources.Step Temperature(
        height=10,
        offset=297,
        startTime=20)   annotation (extent=[-50,50; -30,70]);
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[-10,70; 10,90]);
      ThermoPower.Thermal.ConvHT ConvEx(N=Nnodes, gamma=400) 
        annotation (extent=[-20,10; 0,30]);
      ThermoPower.Water.SensT T_in(redeclare package Medium=Medium) 
                                   annotation (extent=[-50,-6; -30,14]);
      ThermoPower.Water.SensT T_out(redeclare package Medium=Medium) 
                                    annotation (extent=[40,-6; 60,14]);
    equation 
      connect(hex.outfl, ValveLin1.inlet) annotation (points=[0,0; 10,0], style(
            thickness=2));
      connect(ConvEx.side1, TempSource.wall) 
        annotation (points=[-10,23; -10,37],   style(color=45));
      connect(hex.wall, ConvEx.side2) 
        annotation (points=[-10,5; -10,16.9],    style(color=45));
      connect(T_in.inlet, FluidSource.flange) 
        annotation (points=[-46,0; -60,0], style(thickness=2));
      connect(T_in.outlet, hex.infl) annotation (points=[-34,0; -20,0], style(
            thickness=2));
      connect(ValveLin1.outlet, T_out.inlet) 
        annotation (points=[30,0; 44,0], style(thickness=2));
      connect(T_out.outlet, FluidSink.flange) 
        annotation (points=[56,0; 70,0], style(thickness=2));
      connect(Temperature.y, TempSource.temperature) annotation (points=[-29,60;
            -10,60; -10,44], style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, ValveLin1.cmd) annotation (points=[11,80; 20,80; 20,8],
          style(color=74, rgbcolor={0,0,127}));
    end TestFlow1DfemB;
    
    model TestFlow1DfemC "Test case for Flow1Dfem" 
      package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      // number of Nodes
      parameter Integer Nnodes=20;
      // total length
      parameter Modelica.SIunits.Length Lhex=200;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dihex=0.02;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dihex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dihex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2;
      // friction coefficient
      parameter Real Cfhex=0.005;
      // nominal (and initial) mass flow rate
      parameter Modelica.SIunits.MassFlowRate whex=0.3;
      // initial pressure
      parameter Modelica.SIunits.Pressure phex=1e5;
      // initial specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy hs=1e5;
      ThermoPower.Water.Flow1Dfem hex(
        redeclare package Medium=Medium,
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        HydraulicCapacitance=2,
        hstartin=hs,
        hstartout=hs,
        DynamicMomentum=false,
        pstartin=2*phex,
        pstartout=2*phex,
        alpha=1,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                 annotation (extent=[-20,-10; 0,10]);
      annotation (
        Diagram,
        experiment(StopTime=1000, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1Dfem</tt> (fluid side of a heat exchanger, finite element method). <br>
This model is designed to simulate the flow reversal througth the heat exchanger. The operating fluid is liquid water; the heat flux entering the heat exchanger is set to zero. <br>
During the simulation, flow reversal is achieved:
<ul>
        <li>t=500 s, Negative ramp variation (duration = 20 s) of the mass flow rate trough the heat exchanger. The final mass flow rate has the same magnitude and opposite direction with respect to the initial one.</li>
</ul>
</p>
</p>
<p>
Simulation Interval = [0...1000] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br> 
    First release.</li>
</ul>
</html>"));
      ThermoPower.Water.ValveLin ValveLin1(Kv=2*whex/phex) 
        annotation (extent=[40,-10; 60,10]);
      ThermoPower.Water.SinkP SinkP1(h=hs, p0=4*phex) 
        annotation (extent=[70,-10; 90,10]);
      ThermoPower.Water.SourceW SourceW1(
        w0=whex,
        G=0,
        p0=2*phex,
        h=2*hs) annotation (extent=[-78,-10; -58,10]);
      Modelica.Blocks.Sources.Ramp Ramp1(
        duration=20,
        height=-2*whex,
        offset=whex,
        startTime=500)   annotation (extent=[-100,26; -80,46]);
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[10,50; 30,70]);
      ThermoPower.Thermal.HeatSource1D HeatSource1D1(
        N=Nnodes,
        L=Lhex,
        omega=omegahex) annotation (extent=[-20,20; 0,40]);
      Modelica.Blocks.Sources.Constant Constant2(k=0) 
        annotation (extent=[-40,40; -20,60]);
      ThermoPower.Water.SensT T_in(redeclare package Medium=Medium) 
                                   annotation (extent=[-50,-6; -30,14]);
      ThermoPower.Water.SensT T_out(redeclare package Medium=Medium) 
                                    annotation (extent=[10,-6; 30,14]);
    equation 
      connect(ValveLin1.outlet, SinkP1.flange) 
        annotation (points=[60,0; 70,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(HeatSource1D1.wall, hex.wall) 
        annotation (points=[-10,27; -10,5],    style(color=45));
      connect(SourceW1.flange, T_in.inlet) 
        annotation (points=[-58,0; -46,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(T_in.outlet, hex.infl) annotation (points=[-34,0; -20,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(hex.outfl, T_out.inlet) annotation (points=[0,0; 14,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(T_out.outlet, ValveLin1.inlet) 
        annotation (points=[26,0; 40,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Ramp1.y, SourceW1.in_w0) annotation (points=[-79,36; -72,36; -72,6],
          style(color=74, rgbcolor={0,0,127}));
      connect(Constant2.y, HeatSource1D1.power) annotation (points=[-19,50; -10,
            50; -10,34], style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, ValveLin1.cmd) annotation (points=[31,60; 50,60; 50,8],
          style(color=74, rgbcolor={0,0,127}));
    end TestFlow1DfemC;
    
    model TestFlow1DfemD "Test case for Flow1Dfem" 
      package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      // number of Nodes
      parameter Integer Nnodes=20;
      // total length
      parameter Modelica.SIunits.Length Lhex=10;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dihex=0.02;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dihex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dihex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2;
      // friction coefficient
      parameter Real Cfhex=0.005;
      // nominal (and initial) mass flow rate
      parameter Modelica.SIunits.MassFlowRate whex=1e-2;
      // initial pressure
      parameter Modelica.SIunits.Pressure phex=0.2e5;
      // initial specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy hs=3e6;
      ThermoPower.Water.Flow1Dfem hex(
        redeclare package Medium=Medium,
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        HydraulicCapacitance=2,
        pstartin=phex,
        pstartout=phex,
        alpha=1,
        hstartin=hs,
        hstartout=hs,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                      annotation (extent=[-20,-10; 0,10]);
      ThermoPower.Water.SourceW MassFlowRateSource(
        w0=whex,
        h=hs) annotation (extent=[-60, -10; -40, 10]);
      ThermoPower.Water.SinkP FluidSink(
        p0=0,
        R=100,
        h=3e6) annotation (extent=[76, -10; 96, 10]);
      ThermoPower.Water.ValveLin ValveLin1(Kv=1e-7) 
        annotation (extent=[40, -10; 60, 10]);
      annotation (
        Diagram,
        experiment(StopTime=2, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1Dfem</tt> (fluid side of a heat exchanger, finite element method).<br>
This model is designed to the test compressibility effects. The operating fluid is superheated vapour; the heat flow entering the heat exchanger is set to zero. <br>
During simulation mass flow rate changes:
<ul>
        <li>t=2 s, Step variation of the inlet mass flow rate. The pressure increases with a first order dynamics, the tube actually behaving like a pressurized tank.</li>
</ul>
</p>
</p>
<p>
Simulation Interval = [0...2] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br> 
    First release.</li>
</ul>
</html>"));
      Modelica.Blocks.Sources.Step MassFlowRateStep(
        height=whex/10,
        offset=whex,
        startTime=0.5)   annotation (extent=[-86,20; -66,40]);
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[20,40; 40,60]);
      ThermoPower.Thermal.HeatSource1D HeatSource1D1(
        N=Nnodes,
        L=Lhex,
        omega=omegahex) annotation (extent=[-20,20; 0,40]);
      Modelica.Blocks.Sources.Constant ExtPower(k=0) 
        annotation (extent=[-50,40; -30,60]);
      Water.SensP SensP annotation (extent=[12, 4; 32, 24]);
    equation 
      connect(ValveLin1.inlet, hex.outfl) annotation (points=[40,0; 0,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(ValveLin1.outlet, FluidSink.flange) 
        annotation (points=[60, 0; 76, 0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(MassFlowRateSource.flange, hex.infl) 
        annotation (points=[-40,0; -20,0], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(HeatSource1D1.wall, hex.wall) 
        annotation (points=[-10,27; -10,5], style(color=45));
    initial equation 
      der(hex.p) = 0;
      der(hex.h) = zeros(hex.N);
    equation 
      connect(SensP.flange, ValveLin1.inlet) 
        annotation (points=[22, 10; 40, 10; 40, 0]);
      connect(MassFlowRateStep.y, MassFlowRateSource.in_w0) annotation (points=[
            -65,30; -54,30; -54,6], style(color=74, rgbcolor={0,0,127}));
      connect(ExtPower.y, HeatSource1D1.power) annotation (points=[-29,50; -10,50;
            -10,34], style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, ValveLin1.cmd) annotation (points=[41,50; 50,50; 50,8],
          style(color=74, rgbcolor={0,0,127}));
    end TestFlow1DfemD;
    
    model TestFlow1DfemE "Test case for Flow1Dfem" 
      package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      // number of Nodes
      parameter Integer Nnodes=21;
      // total length
      parameter Modelica.SIunits.Length Lhex=200;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dihex=0.02;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dihex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dihex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2;
      // friction coefficient
      parameter Real Cfhex=0.005;
      // nominal (and initial) mass flow rate
      parameter Modelica.SIunits.MassFlowRate whex=0.31;
      // initial pressure
      parameter Modelica.SIunits.Pressure phex=3e5;
      // initial inlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy hinhex=1e5;
      // initial outlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy houthex=1e5;
      ThermoPower.Water.Flow1Dfem hexA(
        redeclare package Medium=Medium,
        N=Nnodes,
        Nt=1,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        HydraulicCapacitance=2,
        hstartin=hinhex,
        hstartout=houthex,
        pstartin=phex,
        pstartout=phex,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[-20,-50; 0,-30]);
      ThermoPower.Water.SinkP SideA_FluidSink 
        annotation (extent=[70,-50; 90,-30]);
      ThermoPower.Water.SinkP SideB_FluidSink 
        annotation (extent=[-80,40; -100,60]);
      ThermoPower.Water.SourceW SideA_MassFlowRate(
        w0=whex,
        p0=3e5)     annotation (extent=[-78,-50; -58,-30]);
      ThermoPower.Water.ValveLin ValveLin1(Kv=whex/(2e5)) 
        annotation (extent=[20,-50; 40,-30]);
      ThermoPower.Water.ValveLin ValveLin2(Kv=whex/(2e5)) 
        annotation (extent=[-30,40; -50,60]);
      ThermoPower.Water.Flow1Dfem hexB(
        redeclare package Medium=Medium,
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        HydraulicCapacitance=2,
        hstartin=hinhex,
        hstartout=houthex,
        pstartin=phex,
        pstartout=phex,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[0,60; -20,40]);
      annotation (
        Diagram,
        experiment(StopTime=900, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1Dfem</tt> (fluid side of a heat exchanger, finite element method).<br>
This model represent the two fluid sides of a heat exchanger in counterflow configuration. The operating fluid is liquid water.<br> 
The mass flow rate during the experiment and initial conditions are the same for the two sides. <br>
During the simulation, the inlet specific enthalpy for hexA (\"hot side\") is changed:
<ul>
    <li>t=50 s, Step variation of the specific enthalpy of the fluid entering hexA .</li>
</ul>
The outlet temperature of the hot side starts changing after the fluid transport time delay, while the outlet temperature of the cold side starts changing immediately.
</p>
</p>
<p>
Simulation Interval = [0...900] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</HTML>",   revisions="<html>
<ul>
<li><i>20 Dec 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       New heat transfer components.</li>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br> 
    First release.</li>
</ul>

</html>"));
      ThermoPower.Water.SensT SensT_A_in(redeclare package Medium=Medium) 
                                         annotation (extent=[-50,-46; -30,-26]);
      Modelica.Blocks.Sources.Step SideA_InSpecEnth(
        height=1e5,
        offset=1e5,
        startTime=50)   annotation (extent=[-94,-20; -74,0]);
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[-70,70; -50,90]);
      Modelica.Blocks.Sources.Constant Constant2 
        annotation (extent=[4,-20; 24,0]);
      ThermoPower.Water.SensT SensT_B_in(redeclare package Medium=Medium) 
                                         annotation (extent=[30,44; 10,64]);
      ThermoPower.Water.SourceW SideB_MassFlowRate(w0=whex, p0=3e5) 
        annotation (extent=[60,40; 40,60]);
      ThermoPower.Thermal.ConvHT ConvExCF(N=Nnodes, gamma=400) 
        annotation (extent=[-20,-16; 0,4]);
      ThermoPower.Water.SensT SensT_A_out(redeclare package Medium=Medium) 
                                          annotation (extent=[46,-46; 66,-26]);
      ThermoPower.Water.SensT SensT_B_out(redeclare package Medium=Medium) 
                                          annotation (extent=[-54,44; -74,64]);
      Thermal.CounterCurrent CounterCurrent1(N=Nnodes) 
        annotation (extent=[-20,10; 0,30]);
    equation 
      connect(SideA_MassFlowRate.flange, SensT_A_in.inlet) 
        annotation (points=[-58,-40; -46,-40], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SensT_A_in.outlet, hexA.infl) 
        annotation (points=[-34,-40; -20,-40], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(hexA.outfl, ValveLin1.inlet) 
        annotation (points=[0,-40; 20,-40], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(ValveLin2.inlet, hexB.outfl) 
        annotation (points=[-30,50; -20,50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SensT_B_in.outlet, hexB.infl) annotation (points=[14,50; 0,50],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SideB_MassFlowRate.flange, SensT_B_in.inlet) 
        annotation (points=[40,50; 26,50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(ValveLin1.outlet, SensT_A_out.inlet) 
        annotation (points=[40,-40; 50,-40], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SensT_A_out.outlet, SideA_FluidSink.flange) 
        annotation (points=[62,-40; 70,-40], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SideB_FluidSink.flange, SensT_B_out.outlet) 
        annotation (points=[-80,50; -70,50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SensT_B_out.inlet, ValveLin2.outlet) 
        annotation (points=[-58,50; -50,50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(ConvExCF.side2, hexA.wall) annotation (points=[-10,-9.1; -10,-35],
          style(color=45, rgbcolor={255,127,0}));
      connect(hexB.wall, CounterCurrent1.side1) annotation (points=[-10,45; -10,
            23],    style(color=45, rgbcolor={255,127,0}));
      connect(CounterCurrent1.side2, ConvExCF.side1) annotation (points=[-10,16.9;
            -10,-3],         style(color=45, rgbcolor={255,127,0}));
      connect(SideA_InSpecEnth.y, SideA_MassFlowRate.in_h) annotation (points=[
            -73,-10; -64,-10; -64,-34], style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, ValveLin2.cmd) annotation (points=[-49,80; -40,80; -40,
            58], style(color=74, rgbcolor={0,0,127}));
      connect(Constant2.y, ValveLin1.cmd) annotation (points=[25,-10; 30,-10; 30,
            -32], style(color=74, rgbcolor={0,0,127}));
    end TestFlow1DfemE;
    
    model TestFlow1DfemF "Test case for Flow1Dfem" 
      package Medium=Modelica.Media.Water.WaterIF97OnePhase_ph;
      // number of Nodes
      parameter Integer Nnodes=20;
      // total length
      parameter Modelica.SIunits.Length Lhex=200;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dihex=0.02;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dihex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dihex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2;
      // friction coefficient
      parameter Real Cfhex=0.005;
      // nominal (and initial) mass flow rate
      parameter Modelica.SIunits.MassFlowRate whex=0.31;
      // initial pressure
      parameter Modelica.SIunits.Pressure phex=3e5;
      // initial inlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy hinhex=1e5;
      // initial outlet specific enthalpy 
      parameter Modelica.SIunits.SpecificEnthalpy houthex=1e5;
      ThermoPower.Water.Flow1Dfem hexA(
        redeclare package Medium=Medium,
        N=Nnodes,
        Nt=1,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        HydraulicCapacitance=2,
        hstartin=hinhex,
        hstartout=houthex,
        pstartin=phex,
        pstartout=phex,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[-20,-60; 0,-40]);
      ThermoPower.Thermal.ConvHT ConvHTc1(N=Nnodes, gamma=400) 
        annotation (extent=[-20,18; 0,38]);
      ThermoPower.Thermal.ConvHT ConvHTe1(N=Nnodes, gamma=400) 
        annotation (extent=[-20,-36; 0,-16]);
      ThermoPower.Water.SinkP SideA_FluidSink 
        annotation (extent=[70,-60; 90,-40]);
      ThermoPower.Water.SinkP SideB_FluidSink 
        annotation (extent=[-80,40; -100,60]);
      ThermoPower.Water.SourceW SideA_MassFlowRate(
        w0=whex,
        p0=3e5)     annotation (extent=[-82,-60; -62,-40]);
      ThermoPower.Water.ValveLin ValveLin1(Kv=whex/(2e5)) 
        annotation (extent=[20,-60; 40,-40]);
      ThermoPower.Water.ValveLin ValveLin2(Kv=whex/(2e5)) 
        annotation (extent=[-30,40; -50,60]);
      ThermoPower.Water.Flow1Dfem hexB(
        redeclare package Medium=Medium,
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dihex,
        A=Ahex,
        wnom=whex,
        Cfnom=Cfhex,
        HydraulicCapacitance=2,
        hstartin=hinhex,
        hstartout=houthex,
        pstartin=phex,
        pstartout=phex,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[0,60; -20,40]);
      ThermoPower.Thermal.MetalTube MetalWall(
        N=Nnodes,
        L=Lhex,
        lambda=20,
        rint=rhex,
        rext=rhex + 1e-3,
        rhomcm=4.9e6,
        Tstart1=297,
        TstartN=297,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[-20,0; 0,-20]);
      annotation (
        Diagram,
        experiment(StopTime=900, Tolerance=1e-006),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1Dfem</tt> (fluid side of a heat exchanger, finite element method).<br>
This model represent the two fluid sides of a heat exchanger in counterflow configuration. The two sides are divided by a metal wall. The operating fluid is liquid water. The mass flow rate during the experiment and initial conditions are the same for the two sides. <br>
During the simulation, the inlet specific enthalpy for hexA (\"hot side\") is changed:
<ul>
    <li>t=50 s, Step variation of the specific enthalpy of the fluid entering hexA .</li>
</ul>
The outlet temperature of the hot side changes after the fluid transport time delay and the first order delay due to the wall's thermal inertia. The outlet temperature of the cold side starts changing after the thermal inertia delay. </p>
<p>
Simulation Interval = [0...900] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</HTML>",   revisions="<html>
<ul>
<li><i>20 Dec 2004</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       New heat transfer components.</li>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br>
    First release.</li>
</ul>

</html>"));
      ThermoPower.Water.SensT SensT_A_in(redeclare package Medium=Medium) 
                                         annotation (extent=[-52,-56; -32,-36]);
      Modelica.Blocks.Sources.Step SideA_InSpecEnth(
        height=1e5,
        offset=1e5,
        startTime=50)   annotation (extent=[-96,-34; -76,-14]);
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[-70,70; -50,90]);
      Modelica.Blocks.Sources.Constant Constant2 
        annotation (extent=[4,-40; 24,-20]);
      ThermoPower.Water.SensT SensT_B_in(redeclare package Medium=Medium) 
                                         annotation (extent=[30,44; 10,64]);
      ThermoPower.Water.SourceW SourceW1(w0=whex, p0=3e5) 
        annotation (extent=[60,40; 40,60]);
      ThermoPower.Water.SensT SensT_A_out(redeclare package Medium=Medium) 
                                          annotation (extent=[46,-56; 66,-36]);
      ThermoPower.Water.SensT SensT_B_out(redeclare package Medium=Medium) 
                                          annotation (extent=[-54,44; -74,64]);
      Thermal.CounterCurrent CounterCurrent1(N=Nnodes) 
        annotation (extent=[-20,0; 0,20]);
    equation 
      connect(SideA_MassFlowRate.flange, SensT_A_in.inlet) 
        annotation (points=[-62,-50; -48,-50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SensT_A_in.outlet, hexA.infl) 
        annotation (points=[-36,-50; -20,-50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(hexA.outfl, ValveLin1.inlet) 
        annotation (points=[0,-50; 20,-50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(ValveLin2.inlet, hexB.outfl) 
        annotation (points=[-30,50; -20,50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(ConvHTc1.side1, hexB.wall) 
        annotation (points=[-10,31; -10,45],   style(color=45));
      connect(hexA.wall, ConvHTe1.side2) 
        annotation (points=[-10,-45; -10,-29.1],  style(color=45));
      connect(SensT_B_in.outlet, hexB.infl) annotation (points=[14,50; 0,50],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SourceW1.flange, SensT_B_in.inlet) 
        annotation (points=[40,50; 26,50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(MetalWall.int, ConvHTe1.side1) 
        annotation (points=[-10,-13; -10,-23],
                                             style(color=45));
      connect(SensT_A_out.inlet, ValveLin1.outlet) 
        annotation (points=[50,-50; 40,-50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SensT_A_out.outlet, SideA_FluidSink.flange) 
        annotation (points=[62,-50; 70,-50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SensT_B_out.outlet, SideB_FluidSink.flange) 
        annotation (points=[-70,50; -80,50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(SensT_B_out.inlet, ValveLin2.outlet) 
        annotation (points=[-58,50; -50,50], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(ConvHTc1.side2, CounterCurrent1.side1) annotation (points=[-10,24.9;
            -10,13], style(color=45, rgbcolor={255,127,0}));
      connect(CounterCurrent1.side2, MetalWall.ext) annotation (points=[-10,6.9;
            -10,-6.9], style(color=45, rgbcolor={255,127,0}));
      connect(SideA_InSpecEnth.y, SideA_MassFlowRate.in_h) annotation (points=[
            -75,-24; -68,-24; -68,-44], style(color=74, rgbcolor={0,0,127}));
      connect(Constant2.y, ValveLin1.cmd) annotation (points=[25,-30; 30,-30; 30,
            -42], style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, ValveLin2.cmd) annotation (points=[-49,80; -40,80; -40,
            58], style(color=74, rgbcolor={0,0,127}));
    end TestFlow1DfemF;
    
    model TestFlow1D2phA "Test case for Flow1D2ph" 
      package Medium=Modelica.Media.Water.WaterIF97_ph;
      import Modelica.Constants.*;
      // number of Nodes
      parameter Integer Nnodes=10;
      // total length
      parameter Length Lhex=10;
      // internal diameter
      parameter Diameter Dhex=0.06;
      // wall thickness
      parameter Thickness thhex=0;
      // internal radius
      parameter Radius rhex=Dhex/2;
      // internal perimeter
      parameter Length omegahex=Dhex;
      // internal cross section
      parameter Area Ahex=pi*rhex^2;
      // friction factor
      parameter Real Cfhex=0.005;
      Modelica.SIunits.Mass Mhex "Mass in the heat exchanger";
      Modelica.SIunits.Mass Mbal "Mass resulting from the mass balance";
      Modelica.SIunits.Mass Merr "Mass balance error";
      
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]),
        Window(
          x=0.01,
          y=0.03,
          width=0.59,
          height=0.55),
        Diagram,
        experiment(
          StopTime=250,
          NumberOfIntervals=2000,
          Tolerance=1e-009),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D2ph</tt> when used as an evaporator.<br>
This model represent the fluid side of a once-through boiler with an applied external heat flow. The operating fluid is water.<br> 
During the simulation, the inlet specific enthalpy and heat flux are changed, while maintaining the inlet flowrate constant:
<ul>
    <li>t=0 s. The initial state of the water is subcooled liquid.
    <li>t=10 s. Ramp increase of the applied heat flow. The water starts boiling and is blown out of the outlet, whose pressure and flowrate undergo a transient increase. At the end of the transient the outlet fluid is in superheated vapour state.</li>
    <li>t=100 s. Step increase of the inlet enthalpy</li> 
    <li>t=150 s. The heat flow is brought back to zero. The vapour collapses, causing a suddend decrease in the outlet pressure and flowrate, until the liquid fills again the entire boiler. At that instant, the flowrate rises again rapidly to the inlet values.</li> 
</ul>
<p>
Simulation Interval = [0...250] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-9 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>26 Jul 2007</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
    Parameters updated.</li>
    <li><i>10 Dec 2005</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
    Parameters updated.</li>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br> 
    First release.</li>
</ul>
</html>"),
        experimentSetupOutput(equdistant=false));
      ThermoPower.Water.Flow1D2ph hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dhex,
        A=Ahex,
        Cfnom=0.005,
        hstartin=6e5,
        hstartout=6e5,
        pstartin=10e5,
        pstartout=10e5,
        wnom=1,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState,
        redeclare package Medium = Medium) 
                     annotation (extent=[-20,-30; 0,-10]);
      ThermoPower.Water.ValveLin valve(           redeclare package Medium = 
            Medium, Kv=0.4/10e5) 
        annotation (extent=[20,-30; 40,-10]);
      ThermoPower.Thermal.HeatSource1D heatSource(
        N=Nnodes,
        L=Lhex,
        omega=omegahex) annotation (extent=[-20,0; 0,20]);
      ThermoPower.Water.SinkP Sink(p0=1e5, redeclare package Medium = Medium) 
                                           annotation (extent=[60,-30; 80,-10]);
      Modelica.Blocks.Sources.Ramp hIn(
        height=1e5,
        offset=4e5,
        startTime=100,
        duration=2)     annotation (extent=[-80,-10; -60,10]);
      Modelica.Blocks.Sources.Ramp extPower(
        startTime=10,
        duration=50,
        height=12e5)   annotation (extent=[-80,26; -60,46]);
      ThermoPower.Water.SourceW Source(      redeclare package Medium = Medium, w0=
           0.4) 
        annotation (extent=[-60,-30; -40,-10]);
      Modelica.Blocks.Sources.Ramp extPower2(
        duration=10,
        startTime=150,
        height=-12e5) annotation (extent=[-80,58; -60,78]);
      Modelica.Blocks.Math.Add Add1 annotation (extent=[-40,40; -20,60]);
      Modelica.Blocks.Sources.Ramp xValve(height=0, offset=1) 
        annotation (extent=[0,20; 20,40]);
    equation 
      connect(heatSource.wall, hex.wall) 
        annotation (points=[-10,7; -10,-15],  style(color=45));
      connect(hex.outfl, valve.inlet) annotation (points=[0,-20; 20,-20], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(valve.outlet, Sink.flange) annotation (points=[40,-20; 60,-20],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Source.flange, hex.infl) annotation (points=[-40,-20; -20,-20],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      Mhex = hex.M;
      der(Mbal) = hex.infl.w + hex.outfl.w;
      Merr = Mhex-Mbal;
    initial equation 
      Mbal = Mhex;
    equation 
      connect(hIn.y, Source.in_h) annotation (points=[-59,0; -46,0; -46,-14],
          style(color=74, rgbcolor={0,0,127}));
      connect(xValve.y, valve.cmd) annotation (points=[21,30; 30,30; 30,-12],
          style(color=74, rgbcolor={0,0,127}));
      connect(Add1.y, heatSource.power) annotation (points=[-19,50; -10,50; -10,
            14], style(color=74, rgbcolor={0,0,127}));
      connect(extPower.y, Add1.u2) annotation (points=[-59,36; -42,44], style(
            color=74, rgbcolor={0,0,127}));
      connect(extPower2.y, Add1.u1) annotation (points=[-59,68; -42,56], style(
            color=74, rgbcolor={0,0,127}));
    end TestFlow1D2phA;
    
    model TestFlow1D2phB "Test case for Flow1D2ph" 
      package Medium=Modelica.Media.Water.WaterIF97_ph;
      import Modelica.Constants.*;
      // number of Nodes
      parameter Integer Nnodes=10;
      // total length
      parameter Length Lhex=10;
      // internal diameter
      parameter Diameter Dhex=0.06;
      // wall thickness
      parameter Thickness thhex=0;
      // internal radius
      parameter Radius rhex=Dhex/2;
      // internal perimeter
      parameter Length omegahex=Dhex;
      // internal cross section
      parameter Area Ahex=pi*rhex^2;
      // friction factor
      parameter Real Cfhex=0.005;
      Modelica.SIunits.Mass Mhex "Mass in the heat exchanger";
      Modelica.SIunits.Mass Mbal "Mass resulting from the mass balance";
      Modelica.SIunits.Mass Merr "Mass balance error";
      
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]),
        Window(
          x=0.01,
          y=0.03,
          width=0.59,
          height=0.55),
        Diagram,
        experiment(
          StopTime=250,
          NumberOfIntervals=2000,
          Tolerance=1e-009),
        Documentation(info="<HTML>
<p>Same as TestFlow1D2phA, but in this case the enthalpy at the inlet changes stepwise. The avodInletEnthalpyDerivative flag is set to true, in order to avoid problems with the derivative of h[1]. 
<p>
Simulation Interval = [0...250] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-9 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>27 Jul 2007</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br> 
    Created.</li>
</ul>
</html>"),
        experimentSetupOutput(equdistant=false));
      ThermoPower.Water.Flow1D2ph hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dhex,
        A=Ahex,
        Cfnom=0.005,
        DynamicMomentum=false,
        hstartin=6e5,
        hstartout=6e5,
        pstartin=10e5,
        pstartout=10e5,
        wnom=1,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState,
        redeclare package Medium = Medium,
        avoidInletEnthalpyDerivative=true) 
                     annotation (extent=[-20,-30; 0,-10]);
      ThermoPower.Water.ValveLin valve(           redeclare package Medium = 
            Medium, Kv=0.4/10e5) 
        annotation (extent=[20,-30; 40,-10]);
      ThermoPower.Thermal.HeatSource1D heatSource(
        N=Nnodes,
        L=Lhex,
        omega=omegahex) annotation (extent=[-20,0; 0,20]);
      ThermoPower.Water.SinkP Sink(p0=1e5, redeclare package Medium = Medium) 
                                           annotation (extent=[60,-30; 80,-10]);
      Modelica.Blocks.Sources.Step hIn(
        height=1e5,
        offset=4e5,
        startTime=100)  annotation (extent=[-80,-10; -60,10]);
      Modelica.Blocks.Sources.Ramp extPower(
        startTime=10,
        duration=50,
        height=12e5)   annotation (extent=[-80,26; -60,46]);
      ThermoPower.Water.SourceW Source(      redeclare package Medium = Medium, w0=
           0.4) 
        annotation (extent=[-60,-30; -40,-10]);
      Modelica.Blocks.Sources.Ramp extPower2(
        duration=10,
        startTime=150,
        height=-12e5) annotation (extent=[-80,58; -60,78]);
      Modelica.Blocks.Math.Add Add1 annotation (extent=[-40,40; -20,60]);
      Modelica.Blocks.Sources.Ramp xValve(height=0, offset=1) 
        annotation (extent=[0,20; 20,40]);
    equation 
      connect(heatSource.wall, hex.wall) 
        annotation (points=[-10,7; -10,-15],  style(color=45));
      connect(hex.outfl, valve.inlet) annotation (points=[0,-20; 20,-20], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(valve.outlet, Sink.flange) annotation (points=[40,-20; 60,-20],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Source.flange, hex.infl) annotation (points=[-40,-20; -20,-20],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      Mhex = hex.M;
      der(Mbal) = hex.infl.w + hex.outfl.w;
      Merr = Mhex-Mbal;
    initial equation 
      Mbal = Mhex;
    equation 
      connect(extPower2.y, Add1.u1) annotation (points=[-59,68; -42,56], style(
            color=74, rgbcolor={0,0,127}));
      connect(extPower.y, Add1.u2) annotation (points=[-59,36; -42,44], style(
            color=74, rgbcolor={0,0,127}));
      connect(Add1.y, heatSource.power) annotation (points=[-19,50; -10,50; -10,
            14], style(color=74, rgbcolor={0,0,127}));
      connect(hIn.y, Source.in_h) annotation (points=[-59,0; -46,0; -46,-14],
          style(color=74, rgbcolor={0,0,127}));
      connect(xValve.y, valve.cmd) annotation (points=[21,30; 30,30; 30,-12],
          style(color=74, rgbcolor={0,0,127}));
    end TestFlow1D2phB;
    
    model TestFlow1D2phC "Test case for Flow1D2ph" 
      package Medium=Modelica.Media.Water.WaterIF97_ph;
      import Modelica.Constants.*;
      // number of Nodes
      parameter Integer Nnodes=10;
      // total length
      parameter Length Lhex=10;
      // internal diameter
      parameter Diameter Dhex=0.06;
      // wall thickness
      parameter Thickness thhex=0;
      // internal radius
      parameter Radius rhex=Dhex/2;
      // internal perimeter
      parameter Length omegahex=Dhex;
      // internal cross section
      parameter Area Ahex=pi*rhex^2;
      // friction factor
      parameter Real Cfhex=0.005;
      Modelica.SIunits.Mass Mhex "Mass in the heat exchanger";
      Modelica.SIunits.Mass Mbal "Mass resulting from the mass balance";
      Modelica.SIunits.Mass Merr "Mass balance error";
      
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]),
        Window(
          x=0.01,
          y=0.03,
          width=0.59,
          height=0.55),
        Diagram,
        experiment(
          StopTime=250,
          NumberOfIntervals=2000,
          Tolerance=1e-009),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D2ph</tt> when used as an evaporator.<br>
This model represent the fluid side of a once-through boiler with an applied external heat flow. The operating fluid is water. The outlet pressure is kept constant, emulating perfect pressure control.<br> 
During the simulation, the inlet specific enthalpy and heat flux are changed, while maintaining the inlet flowrate constant:
<ul>
    <li>t=0 s. The initial state of the water is subcooled liquid.
    <li>t=10 s. Ramp increase of the applied heat flow. The water starts boiling and is blown out of the outlet, whose flowrate undergo a transient increase. At the end of the transient the outlet fluid is in superheated vapour state.</li>
    <li>t=100 s. Step increase of the inlet enthalpy</li> 
    <li>t=150 s. The heat flow is brought back to zero. The vapour collapses, causing a suddend decrease in the outlet flowrate, until the liquid fills again the entire boiler. At that instant, the flowrate rises again rapidly to the inlet values.</li> 
</ul>
<p>
Simulation Interval = [0...250] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-9 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>26 Jul 2007</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
    Parameters updated.</li>
    <li><i>10 Dec 2005</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
    Parameters updated.</li>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br>
    First release.</li>
</ul>
</html>"),
        experimentSetupOutput(equdistant=false));
      ThermoPower.Water.Flow1D2ph hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dhex,
        A=Ahex,
        Cfnom=0.005,
        DynamicMomentum=false,
        pstartin=10e5,
        pstartout=10e5,
        wnom=1,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState,
        redeclare package Medium = Medium,
        hstartin=6e5,
        hstartout=6e5) 
                     annotation (extent=[-10,-30; 10,-10]);
      ThermoPower.Thermal.HeatSource1D heatSource(
        N=Nnodes,
        L=Lhex,
        omega=omegahex) annotation (extent=[-10,0; 10,20]);
      ThermoPower.Water.SinkP Sink(        redeclare package Medium = Medium, p0=
            11e5)                          annotation (extent=[60,-30; 80,-10]);
      Modelica.Blocks.Sources.Ramp hIn(
        height=1e5,
        offset=4e5,
        duration=2,
        startTime=100)  annotation (extent=[-80,-10; -60,10]);
      Modelica.Blocks.Sources.Ramp extPower(
        startTime=10,
        duration=50,
        height=12e5)   annotation (extent=[-80,26; -60,46]);
      ThermoPower.Water.SourceW Source(      redeclare package Medium = Medium, w0=
           0.4) 
        annotation (extent=[-60,-30; -40,-10]);
      Modelica.Blocks.Sources.Ramp extPower2(
        duration=10,
        startTime=150,
        height=-6e5)  annotation (extent=[-80,58; -60,78]);
      Modelica.Blocks.Math.Add Add1 annotation (extent=[-40,40; -20,60]);
    equation 
      connect(heatSource.wall, hex.wall) 
        annotation (points=[0,7; 0,-15],      style(color=45));
      connect(Source.flange, hex.infl) annotation (points=[-40,-20; -10,-20],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      Mhex = hex.M;
      der(Mbal) = hex.infl.w + hex.outfl.w;
      Merr = Mhex-Mbal;
    initial equation 
      Mbal = Mhex;
    equation 
      connect(hex.outfl, Sink.flange) annotation (points=[10,-20; 60,-20], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(extPower.y, Add1.u2) annotation (points=[-59,36; -42,44], style(
            color=74, rgbcolor={0,0,127}));
      connect(extPower2.y, Add1.u1) annotation (points=[-59,68; -42,56], style(
            color=74, rgbcolor={0,0,127}));
      connect(Add1.y, heatSource.power) annotation (points=[-19,50; 0,50; 0,14],
          style(color=74, rgbcolor={0,0,127}));
      connect(hIn.y, Source.in_h) annotation (points=[-59,0; -46,0; -46,-14],
          style(color=74, rgbcolor={0,0,127}));
    end TestFlow1D2phC;
    
    model TestFlow1D2phD "Test case for Flow1D2ph" 
      package Medium=Modelica.Media.Water.WaterIF97_ph;
      import Modelica.Constants.*;
      // number of Nodes
      parameter Integer Nnodes=10;
      // total length
      parameter Length Lhex=10;
      // internal diameter
      parameter Diameter Dhex=0.06;
      // wall thickness
      parameter Thickness thhex=0;
      // internal radius
      parameter Radius rhex=Dhex/2;
      // internal perimeter
      parameter Length omegahex=Dhex;
      // internal cross section
      parameter Area Ahex=pi*rhex^2;
      // friction factor
      parameter Real Cfhex=0.005;
      Modelica.SIunits.Mass Mhex "Mass in the heat exchanger";
      Modelica.SIunits.Mass Mbal "Mass resulting from the mass balance";
      Modelica.SIunits.Mass Merr "Mass balance error";
      
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]),
        Window(
          x=0.01,
          y=0.03,
          width=0.59,
          height=0.55),
        Diagram,
        experiment(
          StopTime=600,
          NumberOfIntervals=2000,
          Tolerance=1e-009),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D2ph</tt> when used as a condenser.<br>
This model represent the fluid side of a condenser with an applied external heat flow. The operating fluid is water.<br> 
During the simulation, the inlet specific enthalpy and heat flux are changed, while maintaining the inlet flowrate constant:
<ul>
    <li>t=0 s. The initial state of the water is superheated vapour.
    <li>t=10 s. Ramp increase of the heat flow extracted from the component. The steam condenses, causing a reduction of pressure and a flow rate transient decrease. At the end of the transient the outlet fluid is in subcooled liquid state.</li>
    <li>t=300 s. Step increase of the inlet enthalpy</li> 
    <li>t=400 s. The heat flow is brought back to zero. The fluids evaporates, causing an increase of pressure and a surge of flow rate at the outlet..</li> 
</ul>
<p>
Simulation Interval = [0...600] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-9 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>26 Jul 2007</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br> 
    Parameters updated.</li>
    <li><i>10 Dec 2005</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
    Parameters updated.</li>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br>
    First release.</li>
</ul>
</html>"),
        experimentSetupOutput(equdistant=false));
      Water.Flow1D2ph hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dhex,
        A=Ahex,
        Cfnom=0.005,
        DynamicMomentum=false,
        pstartin=10e5,
        pstartout=10e5,
        wnom=1,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState,
        redeclare package Medium = Medium,
        hstartin=3.2e6,
        hstartout=3.26e6) 
                     annotation (extent=[-20,-30; 0,-10]);
      ThermoPower.Water.ValveLin valve(           redeclare package Medium = 
            Medium, Kv=0.2/10e5) 
        annotation (extent=[20,-30; 40,-10]);
      ThermoPower.Thermal.HeatSource1D heatSource(
        N=Nnodes,
        L=Lhex,
        omega=omegahex) annotation (extent=[-20,0; 0,20]);
      ThermoPower.Water.SinkP Sink(p0=1e5, redeclare package Medium = Medium) 
                                           annotation (extent=[60,-30; 80,-10]);
      Modelica.Blocks.Sources.Ramp hIn(
        height=1e5,
        duration=2,
        offset=3.2e6,
        startTime=300)  annotation (extent=[-80,-10; -60,10]);
      Modelica.Blocks.Sources.Ramp extPower(
        startTime=10,
        height=-6e5,
        duration=200)  annotation (extent=[-80,26; -60,46]);
      ThermoPower.Water.SourceW Source(      redeclare package Medium = Medium, w0=
           0.2) 
        annotation (extent=[-60,-30; -40,-10]);
      Modelica.Blocks.Sources.Ramp extPower2(
        duration=150,
        height=+6e5,
        startTime=400) 
                      annotation (extent=[-80,58; -60,78]);
      Modelica.Blocks.Math.Add Add1 annotation (extent=[-40,40; -20,60]);
      Modelica.Blocks.Sources.Ramp xValve(height=0, offset=1) 
        annotation (extent=[0,20; 20,40]);
    equation 
      connect(heatSource.wall, hex.wall) 
        annotation (points=[-10,7; -10,-15],  style(color=45));
      connect(hex.outfl, valve.inlet) annotation (points=[0,-20; 20,-20], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(valve.outlet, Sink.flange) annotation (points=[40,-20; 60,-20],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Source.flange, hex.infl) annotation (points=[-40,-20; -20,-20],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      Mhex = hex.M;
      der(Mbal) = hex.infl.w + hex.outfl.w;
      Merr = Mhex-Mbal;
    initial equation 
      Mbal = Mhex;
    equation 
      connect(extPower.y, Add1.u2) annotation (points=[-59,36; -42,44], style(
            color=74, rgbcolor={0,0,127}));
      connect(extPower2.y, Add1.u1) annotation (points=[-59,68; -42,56], style(
            color=74, rgbcolor={0,0,127}));
      connect(hIn.y, Source.in_h) annotation (points=[-59,0; -46,0; -46,-14],
          style(color=74, rgbcolor={0,0,127}));
      connect(Add1.y, heatSource.power) annotation (points=[-19,50; -10,50; -10,
            14], style(color=74, rgbcolor={0,0,127}));
      connect(xValve.y, valve.cmd) annotation (points=[21,30; 30,30; 30,-12],
          style(color=74, rgbcolor={0,0,127}));
    end TestFlow1D2phD;
    
    model CheckFlow1D2phMassBalance 
      "Checks Flow1D2ph equations for mass conservation" 
      package Medium = ThermoPower.Water.StandardWater;
      package SmoothMedium=Medium(final smoothModel = true);
      parameter Integer N = 2;
      constant Modelica.SIunits.Pressure pzero=10 
        "Small deltap for calculations";
      constant Modelica.SIunits.Pressure pc=Medium.fluidConstants[1].criticalPressure;
      constant Modelica.SIunits.SpecificEnthalpy hzero=1e-3 
        "Small value for deltah";
      SmoothMedium.BaseProperties fluid[N] 
        "Properties of the fluid at the nodes";
      Medium.SaturationProperties sat "Properties of saturated fluid";
      Medium.ThermodynamicState dew "Thermodynamic state at dewpoint";
      Medium.ThermodynamicState bubble "Thermodynamic state at bubblepoint";
      Medium.AbsolutePressure p "Fluid pressure for property calculations";
      Medium.Temperature T[N] "Fluid temperature";
      Medium.Temperature Ts "Saturated water temperature";
      Medium.SpecificEnthalpy h[N] "Fluid specific enthalpy";
      Medium.SpecificEnthalpy hl "Saturated liquid temperature";
      Medium.SpecificEnthalpy hv "Saturated vapour temperature";
      Real x[N] "Steam quality";
      Medium.Density rho[N] "Fluid density";
      ThermoPower.LiquidDensity rhol "Saturated liquid density";
      ThermoPower.GasDensity rhov "Saturated vapour density";
    // protected 
      Modelica.SIunits.DerEnthalpyByPressure dhldp 
        "Derivative of saturated liquid enthalpy by pressure";
      Modelica.SIunits.DerEnthalpyByPressure dhvdp 
        "Derivative of saturated vapour enthalpy by pressure";
      ThermoPower.Density rhobar[N - 1] "Fluid average density";
      Modelica.SIunits.DerDensityByPressure drdp[N] 
        "Derivative of density by pressure";
      Modelica.SIunits.DerDensityByPressure drbdp[N - 1] 
        "Derivative of average density by pressure";
      Modelica.SIunits.DerDensityByPressure drldp 
        "Derivative of saturated liquid density by pressure";
      Modelica.SIunits.DerDensityByPressure drvdp 
        "Derivative of saturated vapour density by pressure";
      Modelica.SIunits.DerDensityByEnthalpy drdh[N] 
        "Derivative of density by enthalpy";
      Modelica.SIunits.DerDensityByEnthalpy drbdh1[N - 1] 
        "Derivative of average density by left enthalpy";
      Modelica.SIunits.DerDensityByEnthalpy drbdh2[N - 1] 
        "Derivative of average density by right enthalpy";
      Real AA;
      Real AA1;
      import Modelica.Math.*;
      Real rhobar_check[N-1];
      Real rhobar_err[N-1] = rhobar-rhobar_check;
      Real case[N-1];
      
    equation 
      p = 30e5
          - 10e5*min(1,max(0,time-0))
          + 10e5*min(1,max(0,time-2))
          - 10e5*min(1,max(0,time-4))
          + 10e5*min(1,max(0,time-6))
          - 10e5*min(1,max(0,time-8))
          + 10e5*min(1,max(0,time-10))
          - 10e5*min(1,max(0,time-12))
          + 10e5*min(1,max(0,time-14))
          - 10e5*min(1,max(0,time-16))
          + 10e5*min(1,max(0,time-18))
          - 10e5*min(1,max(0,time-20));
      h[1] = 4e5
             + 14e5*min(1,max(0,time-5))
             + 14e5*min(1,max(0,time-7))
             - 14e5*min(1,max(0,time-13))
             - 14e5*min(1,max(0,time-15))
             + 8e5*min(1,max(0,time-17));
      h[2] = 4e5
             + 14e5*min(1,max(0,time-1))
             + 14e5*min(1,max(0,time-3))
             - 14e5*min(1,max(0,time-9))
             - 14e5*min(1,max(0,time-11))
             + 12e5*min(1,max(0,time-17));
      for j in 1:N-1 loop
        der(rhobar_check[j]) = drbdh1[j]*der(h[j])+drbdh2[j]*der(h[j+1])+drbdp[j]*der(p);
      end for;
    initial equation 
      rhobar_check = rhobar;
    equation 
      for j in 1:(N - 1) loop
        if noEvent((h[j] < hl and h[j + 1] < hl) or (h[j] > hv and h[j + 1] >
            hv) or p >= (pc - pzero) or abs(h[j + 1] - h[j]) < hzero) then
          // 1-phase or almost uniform properties
          rhobar[j] = (rho[j] + rho[j+1])/2;
          drbdp[j] = (drdp[j] + drdp[j+1])/2;
          drbdh1[j] = drdh[j]/2;
          drbdh2[j] = drdh[j+1]/2;
          case[j] = 0;
        elseif noEvent(h[j] >= hl and h[j] <= hv and h[j + 1] >= hl and h[j + 1]
             <= hv) then
          // 2-phase
          rhobar[j] = AA*log(rho[j]/rho[j+1]) / (h[j+1] - h[j]);
          drbdp[j] = (AA1*log(rho[j]/rho[j+1]) +
                      AA*(1/rho[j] * drdp[j] - 1/rho[j+1] * drdp[j+1])) /
                     (h[j+1] - h[j]);
          drbdh1[j] = (rhobar[j] - rho[j]) / (h[j+1] - h[j]);
          drbdh2[j] = (rho[j+1] - rhobar[j]) / (h[j+1] - h[j]);
          case[j] = 1;
        elseif noEvent(h[j] < hl and h[j + 1] >= hl and h[j + 1] <= hv) then
          // liquid/2-phase
          rhobar[j] = ((rho[j] + rhol)*(hl - h[j])/2 + AA*log(rhol/rho[j+1])) /
                      (h[j+1] - h[j]);
          drbdp[j] = ((drdp[j] + drldp)*(hl - h[j])/2 + (rho[j]+rhol)/2 * dhldp +
                       AA1*log(rhol/rho[j+1]) +
                       AA*(1/rhol * drldp - 1/rho[j+1] * drdp[j+1])) / (h[j+1] - h[j]);
          drbdh1[j] = (rhobar[j] - (rho[j]+rhol)/2 + drdh[j]*(hl-h[j])/2) / (h[j+1] - h[j]);
          drbdh2[j] = (rho[j+1] - rhobar[j]) / (h[j+1] - h[j]);
          case[j] = 2;
        elseif noEvent(h[j] >= hl and h[j] <= hv and h[j + 1] > hv) then
          // 2-phase/vapour
          rhobar[j] = (AA*log(rho[j]/rhov) + (rhov + rho[j+1])*(h[j+1] - hv)/2) /
                      (h[j+1] - h[j]);
          drbdp[j] = (AA1*log(rho[j]/rhov) +
                      AA*(1/rho[j] * drdp[j] - 1/rhov *drvdp) +
                      (drvdp + drdp[j+1])*(h[j+1] - hv)/2 - (rhov+rho[j+1])/2 * dhvdp) /
                     (h[j + 1] - h[j]);
          drbdh1[j] = (rhobar[j] - rho[j]) / (h[j+1] - h[j]);
          drbdh2[j] = ((rhov+rho[j+1])/2 - rhobar[j] + drdh[j+1]*(h[j+1]-hv)/2) /
                      (h[j+1] - h[j]);
          case[j] = 3;
        elseif noEvent(h[j] < hl and h[j + 1] > hv) then
          // liquid/2-phase/vapour
          rhobar[j] = ((rho[j] + rhol)*(hl - h[j])/2 + AA*log(rhol/rhov) +
                       (rhov + rho[j+1])*(h[j+1] - hv)/2) / (h[j+1] - h[j]);
          drbdp[j] = ((drdp[j] + drldp)*(hl - h[j])/2 + (rho[j]+rhol)/2 * dhldp +
                      AA1*log(rhol/rhov) + AA*(1/rhol * drldp - 1/rhov * drvdp) +
                      (drvdp + drdp[j+1])*(h[j+1] - hv)/2 - (rhov+rho[j+1])/2 * dhvdp) /
                     (h[j+1] - h[j]);
          drbdh1[j] = (rhobar[j] - (rho[j]+rhol)/2 + drdh[j]*(hl-h[j])/2) / (h[j+1] - h[j]);
          drbdh2[j] = ((rhov+rho[j+1])/2 - rhobar[j] + drdh[j+1]*(h[j+1]-hv)/2) / (h[j+1] - h[j]);
          case[j] = 4;
        elseif noEvent(h[j] >= hl and h[j] <= hv and h[j + 1] < hl) then
          // 2-phase/liquid
          rhobar[j] = (AA*log(rho[j]/rhol) + (rhol + rho[j+1])*(h[j+1] - hl)/2) /
                      (h[j+1] - h[j]);
          drbdp[j] = (AA1*log(rho[j]/rhol) +
                      AA*(1/rho[j] * drdp[j] - 1/rhol * drldp) +
                      (drldp + drdp[j+1])*(h[j+1] - hl)/2 - (rhol + rho[j+1])/2 * dhldp) /
                     (h[j + 1] - h[j]);
          drbdh1[j] = (rhobar[j] - rho[j]) / (h[j+1] - h[j]);
          drbdh2[j] = ((rhol+rho[j+1])/2 - rhobar[j] + drdh[j+1]*(h[j+1]-hl)/2) / (h[j+1] - h[j]);
          case[j] = 5;
        elseif noEvent(h[j] > hv and h[j + 1] < hl) then
          // vapour/2-phase/liquid
          rhobar[j] = ((rho[j] + rhov)*(hv - h[j])/2 + AA*log(rhov/rhol) +
                       (rhol + rho[j+1])*(h[j+1] - hl)/2) / (h[j+1] - h[j]);
          drbdp[j] = ((drdp[j] + drvdp)*(hv - h[j])/2 + (rho[j]+rhov)/2 * dhvdp +
                      AA1*log(rhov/rhol) +
                      AA*(1/rhov * drvdp - 1/rhol * drldp) +
                      (drldp + drdp[j+1])*(h[j+1] - hl)/2 - (rhol+rho[j+1])/2 * dhldp) /
                     (h[j+1] - h[j]);
          drbdh1[j] = (rhobar[j] - (rho[j]+rhov)/2 + drdh[j]*(hv-h[j])/2) / (h[j+1] - h[j]);
          drbdh2[j] = ((rhol+rho[j+1])/2 - rhobar[j] + drdh[j+1]*(h[j+1]-hl)/2) / (h[j+1] - h[j]);
          case[j] = 6;
        else
          // vapour/2-phase
          rhobar[j] = ((rho[j] + rhov)*(hv - h[j])/2 + AA*log(rhov/rho[j+1])) / (h[j+1] - h[j]);
          drbdp[j] = ((drdp[j] + drvdp)*(hv - h[j])/2 + (rho[j]+rhov)/2 * dhvdp +
                      AA1*log(rhov/rho[j+1]) + AA*(1/rhov * drvdp - 1/rho[j+1] * drdp[j+1])) /
                     (h[j + 1] - h[j]);
          drbdh1[j] = (rhobar[j] - (rho[j]+rhov)/2 + drdh[j]*(hv-h[j])/2) / (h[j+1] - h[j]);
          drbdh2[j] = (rho[j+1] - rhobar[j]) / (h[j+1] - h[j]);
          case[j] = 7;
        end if;
      end for;
      
      // Saturated fluid property calculations
      sat = Medium.setSat_p(p);
      Ts=sat.Tsat;
      bubble=Medium.setBubbleState(sat,1);
      dew=Medium.setDewState(sat,1);
      rhol=Medium.bubbleDensity(sat);
      rhov=Medium.dewDensity(sat);
      hl=Medium.bubbleEnthalpy(sat);
      hv=Medium.dewEnthalpy(sat);
      drldp=Medium.dBubbleDensity_dPressure(sat);
      drvdp=Medium.dDewDensity_dPressure(sat);
      dhldp=Medium.dBubbleEnthalpy_dPressure(sat);
      dhvdp=Medium.dDewEnthalpy_dPressure(sat);
      AA = (hv - hl)/(1/rhov - 1/rhol);
      AA1 = ((dhvdp - dhldp)*(rhol - rhov)*rhol*rhov
              - (hv - hl)*(rhov^2*drldp - rhol^2*drvdp))/(rhol - rhov)^2;
      
      // Fluid property calculations
      for j in 1:N loop
        fluid[j].p=p;
        fluid[j].h=h[j];
        T[j]=fluid[j].T;
        rho[j]=fluid[j].d;
        drdp[j]=Medium.density_derp_h(fluid[j].state);
        drdh[j]=Medium.density_derh_p(fluid[j].state);
        x[j]=noEvent(if h[j]<=hl then 0 else 
                  if h[j]>=hv then 1 else (h[j]-hl)/(hv-hl));
      end for;
      annotation (
        experiment(
          StopTime=19,
          NumberOfIntervals=5000,
          Tolerance=1e-009),
        experimentSetupOutput,
        Documentation(info="<html>
This model checks the dynamic mass balance equations of Flow1D2ph, by prescribing enthalpy and pressure values that will ensure complete coverage of the different cases.
</html>"));
      
    end CheckFlow1D2phMassBalance;
    
    model TestFlow1D2phDB "Test case for Flow1D2phDB" 
      package Medium=Modelica.Media.Water.WaterIF97_ph;
      import Modelica.Constants.*;
      // number of Nodes
      parameter Integer Nnodes=8;
      // total length
      parameter Length Lhex=20;
      // internal diameter
      parameter Diameter Dhex=0.01;
      // wall thickness
      parameter Thickness thhex=0.002;
      // internal radius
      parameter Radius rhex=Dhex/2;
      // internal perimeter
      parameter Length omegahex=pi*Dhex;
      // internal cross section
      parameter Area Ahex=pi*rhex^2;
      // friction factor
      parameter Real Cfhex=0.005;
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]),
        Window(
          x=0.01,
          y=0.03,
          width=0.59,
          height=0.55),
        Diagram,
        experiment(
          StopTime=1000,
          NumberOfIntervals=5000,
          Tolerance=1e-008),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D2phDB</tt> (fluid side of a heat exchanger, finite volumes, two-phase flow, computation of the heat transfer coefficient).<br>
This model represent the fluid side of a once-through boiler with an applied external linear temperature profile. The operating fluid is water.<br> 
The simulation proceeds through the following steps:
<ul>
    <li>t=0 s. The initial state of the water is subcooled liquid. After 40 seconds all the thermal transients have settled.
    <li>t=100 s. Ramp increase of the external temperature profile. The water starts boiling at t=118 s. At the end of the transient (t=300) the outlet fluid is superheated vapour.</li>
    <li>t=500 s. Ramp decrease of the external temperature profile. After the transient has settled, the fluid in the boiler is again subcooled water.</li> 
</ul>
<p> During the transient it is possible to observe the change in the heat transfer coefficients when boiling takes place; note that the h.t.c.'s  do not change abruptly due to the smoothing algorithm inside the <tt>Flow1D2phDB</tt> model.
<p>
Simulation Interval = [0...1000] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-8 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>4 Feb 2004</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br> 
    First release.</li>
</ul>
</html>"));
      ThermoPower.Water.Flow1D2phDB hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        A=Ahex,
        Cfnom=0.005,
        DynamicMomentum=false,
        hstartin=1e6,
        hstartout=1e6,
        pstartin=60e5,
        pstartout=60e5,
        gamma_b=20000,
        Dhyd=2*rhex,
        wnom=0.05,
        redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                  annotation (extent=[-20,-70; 0,-50]);
      ThermoPower.Water.ValveLin valve(Kv=0.05/60e5) 
        annotation (extent=[30,-70; 50,-50]);
      ThermoPower.Water.SinkP Sink(p0=0) annotation (extent=[70,-70; 90,-50]);
      Modelica.Blocks.Sources.Step hIn(
        height=0,
        offset=1e6,
        startTime=30) annotation (extent=[-80,-40; -60,-20]);
      Modelica.Blocks.Sources.Ramp extTemp1(
        duration=100,
        height=50,
        offset=540,
        startTime=100)  annotation (extent=[-100,20; -80,40]);
      ThermoPower.Water.SourceW Source(
        w0=0.05,
        p0=60e5,
        G=0.05/600e5) annotation (extent=[-60,-70; -40,-50]);
      Modelica.Blocks.Sources.Ramp extTemp2(
        duration=100,
        height=-50,
        startTime=500)  annotation (extent=[-100,60; -80,80]);
      Modelica.Blocks.Math.Add Add1 annotation (extent=[-66,40; -46,60]);
      Modelica.Blocks.Sources.Ramp xValve(height=0, offset=1) 
        annotation (extent=[10,-40; 30,-20]);
      Thermal.MetalTube Tube(
        N=Nnodes,
        L=Lhex,
        rint=rhex,
        rhomcm=7000*680,
        lambda=20,
        rext=rhex + 2*thhex,
        Tstart1=510,
        TstartN=510,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[-20,-6; 0,-26]);
      Thermal.ConvHT_htc htFluid(N=Nnodes) 
        annotation (extent=[-20,-26; 0,-46]);
      Thermal.ConvHT htExt(N=Nnodes, gamma=10000) 
        annotation (extent=[-20,-6; 0,14]);
      Thermal.TempSource1Dlin tempSource(N=Nnodes) 
        annotation (extent=[-20,16; 0,36]);
      Modelica.Blocks.Math.Add Add2 annotation (extent=[0,70; 20,90]);
      Modelica.Blocks.Sources.Constant DT(k=5) 
        annotation (extent=[-36,60; -16,80]);
    equation 
      connect(hex.outfl, valve.inlet) annotation (points=[0,-60; 30,-60], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(valve.outlet, Sink.flange) annotation (points=[50,-60; 70,-60],
          style(color=3, rgbcolor={0,0,255}));
      connect(Source.flange, hex.infl) annotation (points=[-40,-60; -20,-60],
          style(thickness=2));
      connect(htExt.side2, Tube.ext) 
        annotation (points=[-10,0.9; -10,-12.9],   style(color=45));
      connect(Tube.int, htFluid.otherside) 
        annotation (points=[-10,-19; -10,-33], style(color=45));
      connect(htFluid.fluidside, hex.wall) 
        annotation (points=[-10,-39; -10,-55]);
      connect(tempSource.wall, htExt.side1) 
        annotation (points=[-10,23; -10,7],    style(color=45));
      connect(hIn.y, Source.in_h) annotation (points=[-59,-30; -46,-30; -46,-54],
          style(color=74, rgbcolor={0,0,127}));
      connect(tempSource.temperature_node1, Add1.y) annotation (points=[-14,29;
            -14,50; -45,50], style(color=74, rgbcolor={0,0,127}));
      connect(tempSource.temperature_nodeN, Add2.y) annotation (points=[-6,28.8;
            -6,50; 30,50; 30,80; 21,80], style(color=74, rgbcolor={0,0,127}));
      connect(Add2.u2, DT.y) annotation (points=[-2,74; -8,74; -8,70; -15,70],
          style(color=74, rgbcolor={0,0,127}));
      connect(Add2.u1, Add1.y) annotation (points=[-2,86; -40,86; -40,50; -45,50],
          style(color=74, rgbcolor={0,0,127}));
      connect(xValve.y, valve.cmd) annotation (points=[31,-30; 40,-30; 40,-52],
          style(color=74, rgbcolor={0,0,127}));
      connect(extTemp1.y, Add1.u2) annotation (points=[-79,30; -68,44], style(
            color=74, rgbcolor={0,0,127}));
      connect(extTemp2.y, Add1.u1) annotation (points=[-79,70; -68,56], style(
            color=74, rgbcolor={0,0,127}));
    end TestFlow1D2phDB;
    
    model TestFlow1D2phDB_hf "Test case for Flow1D2ph" 
      package Medium=Modelica.Media.Water.WaterIF97_ph(smoothModel=true);
      import Modelica.Constants.*;
      // number of Nodes
      parameter Integer Nnodes=10;
      // total length
      parameter Modelica.SIunits.Length Lhex=10;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dhex=0.02;
      // wall thickness
      parameter Modelica.SIunits.Thickness thhex=0;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dhex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Dhex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=pi*rhex^2;
      // friction factor
      parameter Real Cfhex=0.005;
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]),
        Window(
          x=0.01,
          y=0.03,
          width=0.59,
          height=0.55),
        Diagram,
        experiment(
          StopTime=300,
          NumberOfIntervals=2000,
          Tolerance=1e-007),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D2phDB</tt> (fluid side of a heat exchanger, finite volumes, two-phase flow, heat transfer computation) with a prescribed external heat flux, for debugging purposes. The heat transfer coefficient on the <tt>wall</tt> connector should be a continuous function.
<p>
Simulation Interval = [0...300] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-7 
</p>
</HTML>", revisions="<HTML>
<ul>
    <li><i>11 Oct 2004</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br> 
    First release.</li>
</ul>
</HTML>"),
        experimentSetupOutput(equdistant=false),
        uses(Modelica(version="1.6")));
      ThermoPower.Water.Flow1D2phDB hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dhex,
        A=Ahex,
        Cfnom=0.005,
        DynamicMomentum=false,
        hstartin=6e5,
        hstartout=6e5,
        pstartin=10e5,
        pstartout=10e5,
      redeclare package Medium = Medium,
        wnom=0.1,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom) 
                     annotation (extent=[-30,-50; -10,-30]);
      ThermoPower.Water.ValveLin valve(Kv=0.1/15e5) 
        annotation (extent=[20,-50; 40,-30]);
      ThermoPower.Thermal.HeatSource1Dhtc heatSource(
        N=Nnodes,
        L=Lhex,
        omega=omegahex) annotation (extent=[-30,-28; -10,-8]);
      ThermoPower.Water.SinkP Sink(p0=1e5) annotation (extent=[60,-50; 80,-30]);
      Modelica.Blocks.Sources.Ramp extPower(
        duration=30,
        height=3e5,
        startTime=10)  annotation (extent=[-80,44; -60,64]);
      ThermoPower.Water.SourceW Source(w0=0.1) 
        annotation (extent=[-68,-50; -48,-30]);
      Modelica.Blocks.Sources.Ramp extPower2(
        duration=10,
        height=-3e5,
        startTime=70) annotation (extent=[-80,74; -60,94]);
      Modelica.Blocks.Math.Add Add1 annotation (extent=[-40,60; -20,80]);
      Modelica.Blocks.Sources.Ramp xValve(height=0, offset=1) 
        annotation (extent=[0,-20; 20,0]);
      Modelica.Blocks.Sources.Ramp hIn1(
        duration=30,
        offset=6e5,
        height=2.2e6,
        startTime=120) annotation (extent=[-90,-20; -70,0]);
      Modelica.Blocks.Math.Add Add2 annotation (extent=[40,60; 60,80]);
      Modelica.Blocks.Sources.Ramp extPower1(
        duration=60,
        height=-2.5e5,
        startTime=170) 
                      annotation (extent=[0,74; 20,94]);
      Modelica.Blocks.Sources.Ramp extPower3(
        duration=30,
        height=2.5e5,
        startTime=260) 
                      annotation (extent=[0,44; 20,64]);
      Modelica.Blocks.Math.Add Add3 annotation (extent=[-46,0; -26,20]);
    initial equation 
      der(hex.p) = 0;
      der(hex.htilde) = zeros(Nnodes - 1);
    equation 
      connect(heatSource.wall, hex.wall) 
        annotation (points=[-20,-21; -20,-35],style(color=45));
      connect(hex.outfl, valve.inlet) annotation (points=[-10,-40; 20,-40], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(valve.outlet, Sink.flange) annotation (points=[40,-40; 60,-40],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Source.flange, hex.infl) annotation (points=[-48,-40; -30,-40],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(hIn1.y, Source.in_h) annotation (points=[-69,-10; -54,-10; -54,-34],
          style(color=74, rgbcolor={0,0,127}));
      connect(xValve.y, valve.cmd) annotation (points=[21,-10; 30,-10; 30,-32],
          style(color=74, rgbcolor={0,0,127}));
      connect(Add3.y, heatSource.power) annotation (points=[-25,10; -20,10; -20,
            -14], style(color=74, rgbcolor={0,0,127}));
      connect(Add3.u1, Add2.y) annotation (points=[-48,16; -58,16; -58,30; 70,30;
            70,70; 61,70], style(color=74, rgbcolor={0,0,127}));
      connect(Add3.u2, Add1.y) annotation (points=[-48,4; -66,4; -66,38; -10,38;
            -10,70; -19,70], style(color=74, rgbcolor={0,0,127}));
      connect(extPower.y, Add1.u2) annotation (points=[-59,54; -42,64], style(
            color=74, rgbcolor={0,0,127}));
      connect(extPower2.y, Add1.u1) annotation (points=[-59,84; -42,76], style(
            color=74, rgbcolor={0,0,127}));
      connect(Add2.u1, extPower1.y) 
        annotation (points=[38,76; 21,84], style(color=74, rgbcolor={0,0,127}));
      connect(Add2.u2, extPower3.y) 
        annotation (points=[38,64; 21,54], style(color=74, rgbcolor={0,0,127}));
    end TestFlow1D2phDB_hf;
    
    model TestFlow1D2phChen "Test case for Flow1D2phChen" 
      package Medium=Modelica.Media.Water.WaterIF97_ph;
      import Modelica.Constants.*;
      // number of Nodes
      parameter Integer Nnodes=8;
      // total length
      parameter Length Lhex=20;
      // internal diameter
      parameter Diameter Dhex=0.01;
      // wall thickness
      parameter Thickness thhex=0.002;
      // internal radius
      parameter Radius rhex=Dhex/2;
      // internal perimeter
      parameter Length omegahex=pi*Dhex;
      // internal cross section
      parameter Area Ahex=pi*rhex^2;
      // friction factor
      parameter Real Cfhex=0.005;
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]),
        Window(
          x=0.01,
          y=0.03,
          width=0.59,
          height=0.55),
        Diagram,
        experiment(StopTime=250, Tolerance=1e-008),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D2phDB</tt> (fluid side of a heat exchanger, finite volumes, two-phase flow, computation of the heat transfer coefficient).<br>
This model represent the fluid side of a once-through boiler with an applied external linear temperature profile. The operating fluid is water.<br> 
The simulation proceeds through the following steps:
<ul>
    <li>t=0 s. The initial state of the water is subcooled liquid. After 40 seconds all the thermal transients have settled.
    <li>t=100 s. Ramp increase of the external temperature profile. The water starts boiling at t=118 s. At the end of the transient (t=300) the outlet fluid is superheated vapour.</li>
    <li>t=500 s. Ramp decrease of the external temperature profile. After the transient has settled, the fluid in the boiler is again subcooled water.</li> 
</ul>
<p> During the transient it is possible to observe the change in the heat transfer coefficients when boiling takes place; note that the h.t.c.'s  do not change abruptly due to the smoothing algorithm inside the <tt>Flow1D2phDB</tt> model.
<p>
Simulation Interval = [0...1000] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-8 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>4 Feb 2004</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br> 
    First release.</li>
</ul>
</html>"),
        experimentSetupOutput(equdistant=false));
      ThermoPower.Water.Flow1D2phChen hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        A=Ahex,
        Cfnom=0.005,
        DynamicMomentum=false,
        hstartin=1e6,
        hstartout=1e6,
        pstartin=60e5,
        pstartout=60e5,
        Dhyd=2*rhex,
        redeclare package Medium = Medium,
        wnom=0.05,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.NoFriction,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[-20,-70; 0,-50]);
      ThermoPower.Water.ValveLin valve(Kv=0.05/60e5) 
        annotation (extent=[30,-70; 50,-50]);
      ThermoPower.Water.SinkP Sink(p0=0) annotation (extent=[70,-70; 90,-50]);
      Modelica.Blocks.Sources.Step hIn(
        height=0,
        offset=1e6,
        startTime=30) annotation (extent=[-80,-40; -60,-20]);
      Modelica.Blocks.Sources.Ramp extTemp1(
        duration=100,
        height=60,
        offset=540,
        startTime=100) 
                     annotation (extent=[-100,20; -80,40]);
      ThermoPower.Water.SourceW Source(
        w0=0.05,
        p0=60e5,
        G=0.05/600e5) annotation (extent=[-60,-70; -40,-50]);
      Modelica.Blocks.Sources.Ramp extTemp2(
        duration=100,
        height=-30,
        startTime=500) 
                      annotation (extent=[-100,60; -80,80]);
      Modelica.Blocks.Math.Add Add1 annotation (extent=[-66,40; -46,60]);
      Modelica.Blocks.Sources.Ramp xValve(height=0, offset=1) 
        annotation (extent=[10,-40; 30,-20]);
      Thermal.MetalTube Tube(
        N=Nnodes,
        L=Lhex,
        rint=rhex,
        rhomcm=7000*680,
        lambda=20,
        rext=rhex + 2*thhex,
        Tstart1=510,
        TstartN=510,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                     annotation (extent=[-20,-6; 0,-26]);
      Thermal.ConvHT_htc htFluid(N=Nnodes) 
        annotation (extent=[-20,-26; 0,-46]);
      Thermal.ConvHT htExt(N=Nnodes, gamma=10000) 
        annotation (extent=[-20,-6; 0,14]);
      Thermal.TempSource1Dlin tempSource(N=Nnodes) 
        annotation (extent=[-20,16; 0,36]);
      Modelica.Blocks.Math.Add Add2 annotation (extent=[0,70; 20,90]);
      Modelica.Blocks.Sources.Constant DT(k=5) 
        annotation (extent=[-36,60; -16,80]);
    equation 
      connect(hex.outfl, valve.inlet) 
        annotation (points=[0,-60; 30,-60], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(valve.outlet, Sink.flange) annotation (points=[50,-60; 70,-60],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Source.flange, hex.infl) 
        annotation (points=[-40,-60; -20,-60], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(htExt.side2, Tube.ext) 
        annotation (points=[-10,0.9; -10,-12.9],   style(color=45));
      connect(Tube.int, htFluid.otherside) 
        annotation (points=[-10,-19; -10,-33], style(color=45));
      connect(htFluid.fluidside, hex.wall) 
        annotation (points=[-10,-39; -10,-55]);
      connect(tempSource.wall, htExt.side1) 
        annotation (points=[-10,23; -10,7],    style(color=45));
      connect(hIn.y, Source.in_h) annotation (points=[-59,-30; -46,-30; -46,-54],
          style(color=74, rgbcolor={0,0,127}));
      connect(xValve.y, valve.cmd) annotation (points=[31,-30; 40,-30; 40,-52],
          style(color=74, rgbcolor={0,0,127}));
      connect(Add1.y, tempSource.temperature_node1) annotation (points=[-45,50;
            -14,50; -14,29], style(color=74, rgbcolor={0,0,127}));
      connect(DT.y, Add2.u2) annotation (points=[-15,70; -8,70; -8,74; -2,74],
          style(color=74, rgbcolor={0,0,127}));
      connect(Add2.u1, Add1.y) annotation (points=[-2,86; -40,86; -40,50; -45,50],
          style(color=74, rgbcolor={0,0,127}));
      connect(tempSource.temperature_nodeN, Add2.y) annotation (points=[-6,28.8;
            -6,50; 30,50; 30,80; 21,80], style(color=74, rgbcolor={0,0,127}));
      connect(extTemp1.y, Add1.u2) annotation (points=[-79,30; -68,44], style(
            color=74, rgbcolor={0,0,127}));
      connect(extTemp2.y, Add1.u1) annotation (points=[-79,70; -68,56], style(
            color=74, rgbcolor={0,0,127}));
    end TestFlow1D2phChen;
    
    model TestFlow1D2phChen_hf "Test case for Flow1D2ph" 
      package Medium=Modelica.Media.Water.WaterIF97_ph(smoothModel=true);
      import Modelica.Constants.*;
      // number of Nodes
      parameter Integer Nnodes=10;
      // total length
      parameter Modelica.SIunits.Length Lhex=10;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dhex=0.02;
      // wall thickness
      parameter Modelica.SIunits.Thickness thhex=0;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dhex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Dhex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=pi*rhex^2;
      // friction factor
      parameter Real Cfhex=0.005;
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]),
        Window(
          x=0.01,
          y=0.03,
          width=0.59,
          height=0.55),
        Diagram,
        experiment(
          StopTime=300,
          NumberOfIntervals=2000,
          Tolerance=1e-007),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D2phDB</tt> (fluid side of a heat exchanger, finite volumes, two-phase flow, heat transfer computation) with a prescribed external heat flux, for debugging purposes. The heat transfer coefficient on the <tt>wall</tt> connector should be a continuous function.
<p>
Simulation Interval = [0...300] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-7 
</p>
</HTML>",     revisions="<HTML>
<ul>
    <li><i>11 Oct 2004</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br> 
    First release.</li>
</ul>
</HTML>"),
        experimentSetupOutput(equdistant=false),
        uses(Modelica(version="1.6")));
      ThermoPower.Water.Flow1D2phChen hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dhex,
        A=Ahex,
        Cfnom=0.005,
        DynamicMomentum=false,
        hstartin=6e5,
        hstartout=6e5,
        pstartin=10e5,
        pstartout=10e5,
      redeclare package Medium = Medium,
        wnom=0.1,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.NoFriction) 
                     annotation (extent=[-30,-50; -10,-30]);
      ThermoPower.Water.ValveLin valve(Kv=0.1/15e5) 
        annotation (extent=[20,-50; 40,-30]);
      ThermoPower.Thermal.HeatSource1Dhtc heatSource(
        N=Nnodes,
        L=Lhex,
        omega=omegahex) annotation (extent=[-30,-28; -10,-8]);
      ThermoPower.Water.SinkP Sink(p0=1e5) annotation (extent=[60,-50; 80,-30]);
      Modelica.Blocks.Sources.Ramp extPower(
        duration=30,
        height=3e5,
        startTime=10)  annotation (extent=[-80,44; -60,64]);
      ThermoPower.Water.SourceW Source(w0=0.1) 
        annotation (extent=[-68,-50; -48,-30]);
      Modelica.Blocks.Sources.Ramp extPower2(
        duration=10,
        height=-3e5,
        startTime=70) annotation (extent=[-80,76; -60,96]);
      Modelica.Blocks.Math.Add Add1 annotation (extent=[-40,60; -20,80]);
      Modelica.Blocks.Sources.Ramp xValve(height=0, offset=1) 
        annotation (extent=[0,-20; 20,0]);
      Modelica.Blocks.Sources.Ramp hIn1(
        duration=30,
        offset=6e5,
        height=2.2e6,
        startTime=120) annotation (extent=[-90,-20; -70,0]);
      Modelica.Blocks.Math.Add Add2 annotation (extent=[40,60; 60,80]);
      Modelica.Blocks.Sources.Ramp extPower1(
        duration=60,
        height=-2.5e5,
        startTime=170) 
                      annotation (extent=[0,76; 20,96]);
      Modelica.Blocks.Sources.Ramp extPower3(
        duration=30,
        height=2.5e5,
        startTime=260) 
                      annotation (extent=[0,44; 20,64]);
      Modelica.Blocks.Math.Add Add3 annotation (extent=[-52,0; -32,20]);
    equation 
      connect(heatSource.wall, hex.wall) 
        annotation (points=[-20,-21; -20,-35],style(color=45));
      connect(hex.outfl, valve.inlet) annotation (points=[-10,-40; 20,-40], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(valve.outlet, Sink.flange) annotation (points=[40,-40; 60,-40],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Source.flange, hex.infl) annotation (points=[-48,-40; -30,-40],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
    initial equation 
      der(hex.p) = 0;
      der(hex.htilde) = zeros(Nnodes - 1);
    equation 
      connect(extPower.y, Add1.u2) annotation (points=[-59,54; -42,64], style(
            color=74, rgbcolor={0,0,127}));
      connect(extPower2.y, Add1.u1) annotation (points=[-59,86; -42,76], style(
            color=74, rgbcolor={0,0,127}));
      connect(extPower1.y, Add2.u1) 
        annotation (points=[21,86; 38,76], style(color=74, rgbcolor={0,0,127}));
      connect(extPower3.y, Add2.u2) 
        annotation (points=[21,54; 38,64], style(color=74, rgbcolor={0,0,127}));
      connect(xValve.y, valve.cmd) annotation (points=[21,-10; 30,-10; 30,-32],
          style(color=74, rgbcolor={0,0,127}));
      connect(Source.in_h, hIn1.y) annotation (points=[-54,-34; -54,-10; -69,-10],
          style(color=74, rgbcolor={0,0,127}));
      connect(Add3.y, heatSource.power) annotation (points=[-31,10; -20,10; -20,
            -14], style(color=74, rgbcolor={0,0,127}));
      connect(Add3.u1, Add2.y) annotation (points=[-54,16; -60,16; -60,30; 72,30;
            72,70; 61,70], style(color=74, rgbcolor={0,0,127}));
      connect(Add3.u2, Add1.y) annotation (points=[-54,4; -72,4; -72,36; -10,36;
            -10,70; -19,70], style(color=74, rgbcolor={0,0,127}));
    end TestFlow1D2phChen_hf;
    
    model TestFlow1Dfem2ph "Test case for Flow1D2ph" 
      package Medium=Modelica.Media.Water.WaterIF97_ph;
      // number of Nodes
      parameter Integer Nnodes=11;
      // total length
      parameter Modelica.SIunits.Length Lhex=10;
      // internal diameter
      parameter Modelica.SIunits.Diameter Dhex=0.02;
      // wall thickness
      parameter Modelica.SIunits.Thickness thhex=1e-3;
      // internal radius
      parameter Modelica.SIunits.Radius rhex=Dhex/2;
      // internal perimeter
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dhex;
      // internal cross section
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2;
      // friction factor
      parameter Real Cfhex=0.005;
      
      parameter Modelica.SIunits.SpecificEnthalpy hin=6e5;
      parameter Modelica.SIunits.Pressure phex=1e6;
      parameter Modelica.SIunits.MassFlowRate whex=1;
      
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[2, 2],
          component=[20, 20]),
        Window(
          x=0.01,
          y=0.03,
          width=0.59,
          height=0.55),
        Diagram,
        experiment(StopTime=100, Tolerance=1e-008),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Flow1D2ph</tt> (fluid side of a heat exchanger, finite volumes, two-phase flow).<br>
This model represent the fluid side of a once-through boiler with an applied external heat flow. The operating fluid is water.<br> 
During the simulation, the inlet specific enthalpy and heat flux are changed, while maintaining the inlet flowrate constant:
<ul>
    <li>t=0 s. The initial state of the water is subcooled liquid.
    <li>t=10 s. Ramp increase of the applied heat flow. The water starts boiling and is blown out of the outlet, whose pressure and flowrate undergo a transient increase. At the end of the transient the outlet fluid is in superheated vapour state.</li>
    <li>t=30 s. Step increase of the inlet enthalpy</li> 
    <li>t=50 s. The heat flow is reduced to zero in 2s. The vapour collapses, causing a suddend decrease in the outlet pressure and flowrate, until the liquid fills again the entire boiler. At that instant, the pressure and flowrate rise again rapidly to the inlet values.</li> 
</ul>
<p>
Simulation Interval = [0...80] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</HTML>",   revisions="<html>
<ul>
    <li><i>1 Oct 2003</i> by <a href=\"mailto:francesco.schiavo@polimi.it\">Francesco Schiavo</a>:<br> 
    First release.</li>
</ul>
</html>"),
        experimentSetupOutput(equdistant=false));
      Water.Flow1Dfem2ph hex(
        N=Nnodes,
        L=Lhex,
        omega=omegahex,
        Dhyd=Dhex,
        A=Ahex,
        Cfnom=0.005,
        DynamicMomentum=false,
        hstartin=hin,
        hstartout=hin,
        wnom=1,
        pstartin=phex,
        pstartout=phex,
        ML=0,
      redeclare package Medium = Medium,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom) 
              annotation (extent=[-30,-50; -10,-30]);
      Water.ValveLin valve(Kv=whex/(phex)) 
        annotation (extent=[20,-50; 40,-30]);
      Water.SinkP Sink(p0=0)             annotation (extent=[60,-50; 80,-30]);
      Modelica.Blocks.Sources.Step hIn(
        height=1e5,
        offset=hin,
        startTime=50) annotation (extent=[-90,-20; -70,0]);
      Modelica.Blocks.Sources.Ramp extPower(
        duration=30,
        height=3e6,
        startTime=10)   annotation (extent=[-90,24; -70,44]);
      Water.SourceW Source(
        h=hin,
        w0=whex,
        p0=phex,
        G=0) annotation (extent=[-68,-50; -48,-30]);
      Modelica.Blocks.Sources.Ramp extPower2(
        duration=10,
        height=-3e6,
        startTime=70)    annotation (extent=[-90,54; -70,74]);
      Modelica.Blocks.Math.Add Add1 annotation (extent=[-50,40; -30,60]);
      Modelica.Blocks.Sources.Ramp xValve(height=0, offset=1) 
        annotation (extent=[0,-20; 20,0]);
      Thermal.MetalTube MetalWall(
        N=Nnodes,
        rint=rhex,
        rhomcm=4.9e6,
        L=Lhex,
        lambda=20,
        WallRes=true,
        rext=rhex + thhex,
        Tstart1=415.592,
        TstartN=415.592,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                       annotation (extent=[-30,-20; -10,0],   rotation=180);
      Thermal.HeatSource1D HeatSource1D1(
        N=Nnodes,
        Nt=1,
        L=Lhex,
        omega=(rhex + thhex)*2*Modelica.Constants.pi) 
        annotation (extent=[-30,4; -10,24]);
    equation 
      connect(hex.outfl, valve.inlet) annotation (points=[-10,-40; 20,-40], style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(valve.outlet, Sink.flange) annotation (points=[40,-40; 60,-40],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(Source.flange, hex.infl) annotation (points=[-48,-40; -30,-40],
          style(
          color=3,
          rgbcolor={0,0,255},
          thickness=2));
      connect(hex.wall, MetalWall.int) 
        annotation (points=[-20,-35; -20,-13],         style(color=45));
      connect(HeatSource1D1.wall, MetalWall.ext) annotation (points=[-20,11; -20,
            -6.9],                    style(color=45));
      connect(extPower2.y, Add1.u1) annotation (points=[-69,64; -52,56], style(
            color=74, rgbcolor={0,0,127}));
      connect(extPower.y, Add1.u2) annotation (points=[-69,34; -52,44], style(
            color=74, rgbcolor={0,0,127}));
      connect(hIn.y, Source.in_h) annotation (points=[-69,-10; -54,-10; -54,-34],
          style(color=74, rgbcolor={0,0,127}));
      connect(Add1.y, HeatSource1D1.power) annotation (points=[-29,50; -20,50;
            -20,18], style(color=74, rgbcolor={0,0,127}));
      connect(xValve.y, valve.cmd) annotation (points=[21,-10; 30,-10; 30,-32],
          style(color=74, rgbcolor={0,0,127}));
    end TestFlow1Dfem2ph;
    
    model Flow1D_check 
      "Extended Flow1D model with mass & energy balance computation" 
      
      extends Water.Flow1D;
      SpecificEnergy Etot;
      SpecificEnergy Evol[N - 1];
      Mass Mtot;
      Mass Mvol[N - 1];
      Real balM;
      Real balE;
    equation 
      for j in 1:N - 1 loop
        Mvol[j] = A*l*rhobar[j];
        Evol[j] = Mvol[j]*((h[j] + h[j + 1])/2 - p/rhobar[j]);
      end for;
      // M is computed in base class
      Mtot = M;
      Etot = sum(Evol);
      balM = infl.w + outfl.w;
      
      balE = infl.w*(if infl.w > 0 then infl.hBA else infl.hAB) + outfl.w*(if 
        outfl.w > 0 then outfl.hAB else outfl.hBA) + sum(wall.phi[1:N - 1] +
        wall.phi[2:N])/2*omega*l;
      annotation (Documentation(info="<HTML>
<p>This model extends <tt>Water.Flow1D</tt> by adding the computation of mass and energy flows and buildups. It can be used to check the correctness of the <tt>Water.Flow1D</tt> model.</p>
</HTML>",   revisions="<html>
<ul>
<li><i>1 Oct 2003</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco
Casella</a>:<br>
       First release.</li>
</ul>
</html>"));
    end Flow1D_check;
    
    model TestEvaporatorTemp 
      extends Water.EvaporatorBase(
        redeclare package Medium=Modelica.Media.Water.StandardWater,
        L=30,
        A=1e-4,
        omega=1e-2,
        Dhyd=1e-3,
        wnom=0.1,
        FFtype=0,
        pstartin=10e5,
        hstartin=8e5,
        hstartout=2.9e6,
        csilstart=0.2*L,
        csivstart=0.8*L) 
                  annotation (extent=[-60,-20; 60,40]);
      annotation (experiment(
          StopTime=600,
          NumberOfIntervals=1000,
          Tolerance=1e-008),
          experimentSetupOutput);
      Temperature Text "External temperature";
      parameter Real K( fixed=false, start=1.2e3);
    equation 
      Text=700 - 2*min(max(time-1,0),70)+ 2*min(max(time-300,0),70);
      Ql=K*(Text-fluid_in.T)*csil/L * (1-min(max(time-100,0),160)/200+min(max(time-400,0),200)/200);
      Qb=K*(Text-sat.Tsat)*(csiv-csil)/L * (1-min(max(time-100,0),160)/200+min(max(time-400,0),200)/200);
      Qv=K*(Text-fluid_out.T)*(L-csiv)/L * (1-min(max(time-100,0),160)/200+min(max(time-400,0),200)/200);
      hin=8e5;
      win=0.1;
      wout=0.1/60e5*p;
    initial equation 
      der(csil)=0;
      der(csiv)=0;
      der(hout)=0;
      hout=2.9e6;
      der(p)=0;
    end TestEvaporatorTemp;
    
    model TestEvaporatorFlux 
      extends Water.EvaporatorBase(
        redeclare package Medium=Modelica.Media.Water.StandardWater,
        L=30,
        A=1e-4,
        omega=1e-2,
        Dhyd=1e-3,
        wnom=0.1,
        FFtype=0,
        pstartin=10e5,
        hstartin=4e5,
        hstartout=4e5,
        csilstart=0,
        csivstart=0) 
                  annotation (extent=[-60,-20; 60,40]);
      annotation (experiment(StopTime=30, Tolerance=1e-008),
          experimentSetupOutput);
    equation 
      Ql=2.5e5*csil/L *min(max(time-10,0),100);
      Qb=2.5e5*(csiv-csil)/L * min(max(time-10,0),100);
      Qv=2.5e5*(L-csiv)/L * min(max(time-10,0),100);
      hin=4e5;
      win=0.1;
      wout=0.1/10e5*p;
    initial equation 
      csil=L;
      csiv=L;
      hout=4e5;
      der(p)=0;
    end TestEvaporatorFlux;
    
    model TestGasFlow1DA 
      replaceable package Medium = 
          Modelica.Media.IdealGases.SingleGases.N2 
        extends Modelica.Media.Interfaces.PartialMedium;
      parameter Integer Nnodes=10 "number of Nodes";
      parameter Modelica.SIunits.Length Lhex=200 "total length";
      parameter Modelica.SIunits.Diameter Dihex=0.02 "internal diameter";
      parameter Modelica.SIunits.Radius rhex=Dihex/2 "internal radius";
      parameter Modelica.SIunits.Length omegahex=Modelica.Constants.pi*Dihex 
        "internal perimeter";
      parameter Modelica.SIunits.Area Ahex=Modelica.Constants.pi*rhex^2 
        "internal cross section";
      parameter Real Cfhex=0.005 "friction coefficient";
      parameter Modelica.SIunits.MassFlowRate whex=0.05 
        "nominal (and initial) mass flow rate";
      parameter Modelica.SIunits.Pressure phex=3e5 "initial pressure";
      parameter Temperature Tinhex=300 "initial inlet temperature";
      parameter Temperature Touthex=300 "initial outlet temperature";
     // parameter Temperature deltaT=10 "height of temperature step";
      parameter Modelica.SIunits.EnergyFlowRate W=1e3 "height of power step";
      Modelica.SIunits.Mass Mhex "Mass in the heat exchanger";
      Modelica.SIunits.Mass Mbal "Mass resulting from the mass balance";
      Modelica.SIunits.Mass Merr "Mass balance error";
      
      Gas.SourceW SourceW1(
        redeclare package Medium = Medium,
        p0=phex,
        T=Tinhex,
        w0=whex) annotation (extent=[-78,-10; -58,10]);
      Gas.SinkP SinkP1(
        redeclare package Medium = Medium,
        p0=0.1e5,
        T=300) annotation (extent=[78,-10; 98,10]);
      Gas.SensT SensT1(redeclare package Medium = Medium) 
        annotation (extent=[-50,-6; -30,14]);
      Gas.SensT SensT2(redeclare package Medium = Medium) 
        annotation (extent=[50,-6; 70,14]);
      Gas.Flow1D hex(
        redeclare package Medium = Medium,
        N=Nnodes,
        L=Lhex,
        A=Ahex,
        omega=omegahex,
        Dhyd=Dihex,
        wnom=whex,
        Cfnom=Cfhex,
        Tstartin=Tinhex,
        Tstartout=Touthex,
        pstart=phex,
        FFtype=ThermoPower.Choices.Flow1D.FFtypes.Cfnom,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                      annotation (extent=[-20,-10; 0,10]);
      Gas.ValveLin ValveLin1(redeclare package Medium = Medium, Kv=whex/phex) 
        annotation (extent=[20,-10; 40,10]);
      Thermal.HeatSource1D HeatSource1D1(
        N=Nnodes,
        L=Lhex,
        omega=omegahex) annotation (extent=[-20,16; 0,36]);
      Modelica.Blocks.Sources.Step Step1(height=W, startTime=20) 
        annotation (extent=[-40,40; -20,60]);
    /*  Modelica.Blocks.Sources.Step Step3(
    height=deltaT,
    offset=Tinhex,
    startTime=1) annotation 10;*/
      Modelica.Blocks.Sources.Step Step4(
        height=10,
        offset=Tinhex,
        startTime=10) annotation (extent=[-100,20; -80,40]);
      Modelica.Blocks.Sources.Step Step2(
        height=-0.2,
        offset=1,
        startTime=40) 
        annotation (extent=[0,40; 20,60]);
    equation 
      connect(SourceW1.flange, SensT1.inlet) annotation (points=[-58,0; -46,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(SensT1.outlet, hex.infl)       annotation (points=[-34,0; -20,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(hex.outfl, ValveLin1.inlet)       annotation (points=[0,0; 20,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(ValveLin1.outlet, SensT2.inlet) annotation (points=[40,0; 54,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(SensT2.outlet, SinkP1.flange) annotation (points=[66,0; 78,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(HeatSource1D1.wall, hex.wall)       annotation (points=[-10,23; -10,
            5],           style(color=45, rgbcolor={255,127,0}));
      connect(Step1.y, HeatSource1D1.power) annotation (points=[-19,50; -10,50;
            -10,30],style(color=74, rgbcolor={0,0,127}));
      connect(Step4.y, SourceW1.in_T) annotation (points=[-79,30; -68,30; -68,5],
          style(color=74, rgbcolor={0,0,127}));
      connect(Step2.y, ValveLin1.cmd) annotation (points=[21,50; 30,50; 30,7],
                           style(color=74, rgbcolor={0,0,127}));
      annotation (Diagram, experiment(StopTime=60, Tolerance=1e-007),
        Documentation(info="<HTML>
<p>The model is designed to test the component  <tt>Gas.Flow1D</tt> (fluid side of a heat exchanger, finite volumes).<br>
The model starts at steady state. At t = 10 s, step variation of the temperature of the fluid entering the heat exchanger. At t = 20 s, step variation of the thermal flow entering the heat exchanger lateral surface. At t = 50 s, step reduction of the outlet valve opening.<br>
The working fluid is pure nitrogen.
</ul>
<p>
Simulation Interval = [0...60] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</HTML>"),
        experimentSetupOutput);
      Mhex = hex.M;
      der(Mbal) = hex.infl.w + hex.outfl.w;
      Merr = Mhex-Mbal;
    initial equation 
      Mbal = Mhex;
      
    end TestGasFlow1DA;
    
    model TestGasFlow1DB 
      extends ThermoPower.Test.ThermalElements.TestGasFlow1DA(
        redeclare package Medium = 
            Modelica.Media.IdealGases.MixtureGases.CombustionAir);
      parameter Real deltaX[2]={.05,-.05} "height of composition step";
      
      annotation (
        experiment(StopTime=50),
        experimentSetupOutput,
        Diagram,
        Documentation(info="<html>
Same as <tt>TestGasFlow1DA</tt>, but with mixture fluid (CombustionAir) and UniformComposition = true. The inlet composition is changed stepwise at time t = 30;
</html>"));
      Modelica.Blocks.Sources.Step[2] Step3(
        height=deltaX,
        startTime=30,
        offset=Medium.reference_X) 
                      annotation (extent=[-100,60; -80,80]);
    equation 
      connect(Step3.y, SourceW1.in_X) annotation (points=[-79,70; -62,70; -62,5],
          style(color=74, rgbcolor={0,0,127}));
    end TestGasFlow1DB;
    
    model TestGasFlow1DC 
      extends ThermoPower.Test.ThermalElements.TestGasFlow1DB(
                             hex(UniformComposition=false));
      annotation (Documentation(info="<html>
Same as <tt>TestGasFlow1DB</tt>, but with UniformComposition = false. The outlet composition transient is computed with greater accuracy.
</html>"));
    end TestGasFlow1DC;
    
    model TestGasFlow1DD 
      extends ThermoPower.Test.ThermalElements.TestGasFlow1DB(
                             hex(QuasiStatic=true));
      annotation (Documentation(info="<html>
Same as <tt>TestGasFlow1DB</tt>, but with QuasiStatic = true; the model is purely algebraic (no mass and energy storage).
</html>"));
    end TestGasFlow1DD;
  end ThermalElements;
  
  package GasElements "Test for Gas package elements except Flow1D models" 
    
    model TestGasPlenum 
      package Medium=Modelica.Media.IdealGases.MixtureGases.CombustionAir;
      annotation (Diagram, Documentation(info="<html>
This model tests the <tt>Plenum</tt> model.
<p>Simulate for 1 s. The model starts at steady state. At t = 0.3 the inlet pressure is increased. At t = 0.6 the valve is partially closed.
</html>"),
        experiment(Tolerance=1e-006));
      Gas.ValveLin ValveLin1(redeclare package Medium = Medium, Kv=2.5e-5) 
        annotation (extent=[-42,-10; -22,10]);
      Modelica.Blocks.Sources.Ramp Ramp1(
        offset=1,
        height=-.3,
        duration=0.01,
        startTime=0.6) 
        annotation (extent=[-60,20; -40,40]);
      Gas.SourceP SourceP1(
        redeclare package Medium = Medium,
        p0=5e5,
        T=450)     annotation (extent=[-78,-10; -58,10]);
      Gas.Plenum Plenum1(
        redeclare package Medium = Medium,
        Tstart=400,
        initOpt=ThermoPower.Choices.Init.Options.steadyState,
        inlet(w(start=1.5)),
        pstart=4e5,
        V=0.1) 
              annotation (extent=[0,-10; 20,10]);
      Modelica.Blocks.Sources.Ramp Ramp2(
        startTime=0.3,
        height=3e5,
        offset=5e5,
        duration=0.01) annotation (extent=[-100,20; -80,40]);
      Gas.SinkP SinkP1(
        redeclare package Medium = Medium,
        p0=2e5,
        T=300) annotation (extent=[80,-10; 100,10]);
      Gas.PressDrop PressDrop1(
        redeclare package Medium = Medium,
        pstart=4e5,
        dpnom=2e5,
        Tstart=400,
        rhonom=3,
        A=1,
        wnom=1.5,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint) 
                  annotation (extent=[40,-10; 60,10]);
    equation 
      connect(Ramp1.y, ValveLin1.cmd)   annotation (points=[-39,30; -32,30; -32,7],
                         style(color=74, rgbcolor={0,0,127}));
      connect(ValveLin1.outlet, Plenum1.inlet)     annotation (points=[-22,0; 0,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Ramp2.y, SourceP1.in_p)   annotation (points=[-79,30; -74,30; -74,
            6.4],                style(color=74, rgbcolor={0,0,127}));
      connect(SourceP1.flange, ValveLin1.inlet) annotation (points=[-58,0; -42,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Plenum1.outlet, PressDrop1.inlet) annotation (points=[20,0; 40,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(PressDrop1.outlet, SinkP1.flange) annotation (points=[60,0; 80,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
    end TestGasPlenum;
    
    model TestGasHeader 
      package Medium=Modelica.Media.IdealGases.MixtureGases.AirSteam;
      parameter Real Xnom[Medium.nX]={0.3,0.7};
      Gas.Header Header1(
        redeclare package Medium = Medium,
        Xstart=Xnom,
        Tmstart=300,
        gamma=0.5,
        Cm=1,
        Tstart=450,
        S=0.1,
        pstart=4e5,
        initOpt=ThermoPower.Choices.Init.Options.steadyState,
        V=1)  annotation (extent=[-10,-10; 10,10]);
      Gas.ValveLin ValveLin1(redeclare package Medium = Medium, Kv=0.3e-3) 
        annotation (extent=[30,-10; 50,10]);
      Gas.SinkP SinkP2(
        redeclare package Medium = Medium,
        Xnom=Xnom,
        p0=2e5,
        T=350)    annotation (extent=[70,-10; 90,10]);
      Gas.PressDrop PressDrop1(
        redeclare package Medium = Medium,
        Xstart=Xnom,
        rhonom=5,
        pstart=5e5,
        Tstart=450,
        wnom=1,
        dpnom=1e5,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint) 
                  annotation (extent=[-50,-10; -30,10]);
      Modelica.Blocks.Sources.Step Step1(
        offset=1,
        height=-.3,
        startTime=0.1) annotation (extent=[10,20; 30,40]);
      Gas.SourceW SourceW1(
        redeclare package Medium = Medium,
        Xnom=Xnom,
        w0=5,
        p0=5e5,
        T=450) annotation (extent=[-90,-10; -70,10]);
    initial equation 
      
    equation 
      connect(ValveLin1.outlet, SinkP2.flange)     annotation (points=[50,0; 70,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(PressDrop1.outlet, Header1.inlet) annotation (points=[-30,0; -10,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Header1.outlet, ValveLin1.inlet) annotation (points=[10,0; 30,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Step1.y, ValveLin1.cmd) annotation (points=[31,30; 40,30; 40,7],
                   style(color=74, rgbcolor={0,0,127}));
      connect(SourceW1.flange, PressDrop1.inlet) annotation (points=[-70,0; -50,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      annotation (
        Icon,
        Diagram,
        uses(Modelica(version="2.1")),
        Documentation(info="<html>
This model tests the <tt>Header</tt> model.

<p>Simulate for 1 s. The model starts at steady state. At t=0.1 the valve is partially closed.
</html>"),
        experiment,
        experimentSetupOutput);
    end TestGasHeader;
    
    model TestGasMixer 
      package Medium=Modelica.Media.IdealGases.MixtureGases.CombustionAir;
      parameter Real wext=10;
      Gas.Mixer Mixer1(
        redeclare package Medium = Medium,
        Tmstart=300,
        gamma=0.8,
        S=1,
        V=3,
        Tstart=450,
        pstart=4e5,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
               annotation (extent=[-38,-10; -18,10]);
      Gas.PressDrop PressDrop1(
        redeclare package Medium = Medium,
        A=0.1,
        dpnom=1e5,
        rhonom=3.5,
        wnom=wext,
        pstart=4e5,
        Tstart=400,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint) 
               annotation (extent=[0,-10; 22,10]);
      Gas.SinkP SinkP1(
        redeclare package Medium = Medium,
        p0=1e5,
        T=350)  annotation (extent=[76,-10; 96,10]);
      Gas.SourceW SourceW2(
        redeclare package Medium = Medium,
        w0=15,
        p0=4e5,
        T=350,
        Xnom={0.5,0.5}) 
               annotation (extent=[-76,-40; -56,-20]);
      Modelica.Blocks.Sources.Step Step1(
        height=-.2,
        offset=1.5,
        startTime=15)  annotation (extent=[20,30; 40,50]);
      Gas.Valve Valve1(
        redeclare package Medium = Medium,
        Tstart=400,
        dpnom=2e5,
        pnom=3e5,
        wnom=wext,
        Av=5e-4,
        CvData=ThermoPower.Choices.Valve.CvTypes.OpPoint) 
                 annotation (extent=[40,-10; 60,10]);
      Modelica.Blocks.Sources.Ramp Ramp1(
        offset=wext,
        height=-1,
        duration=0.1,
        startTime=8) 
                   annotation (extent=[-100,-20; -80,0]);
      Modelica.Blocks.Sources.Ramp Ramp2(
        height=-1,
        offset=5,
        duration=0.1,
        startTime=1) annotation (extent=[-100,40; -80,60]);
      Gas.SourceW SourceW1(
        redeclare package Medium = Medium,
        p0=4e5,
        T=450)     annotation (extent=[-74,18; -54,38]);
    equation 
      connect(Mixer1.out, PressDrop1.inlet)     annotation (points=[-18,0; 0,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(SourceW2.flange, Mixer1.in2)     annotation (points=[-56,-30; -44,
            -30; -44,-6; -36,-6], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(PressDrop1.outlet, Valve1.inlet) annotation (points=[22,0; 40,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Valve1.outlet, SinkP1.flange) annotation (points=[60,0; 76,0],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Step1.y, Valve1.theta) annotation (points=[41,40; 50,40; 50,7.2],
                      style(color=74, rgbcolor={0,0,127}));
      connect(Ramp1.y, SourceW2.in_w0) annotation (points=[-79,-10; -72,-10; -72,
            -25],      style(color=74, rgbcolor={0,0,127}));
      connect(SourceW1.flange, Mixer1.in1) annotation (points=[-54,28; -44,28;
            -44,6; -36,6], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Ramp2.y, SourceW1.in_w0) annotation (points=[-79,50; -70,50; -70,33],
                         style(color=74, rgbcolor={0,0,127}));
    annotation (Diagram, experiment(StopTime=20),
        Documentation(info="<html>
This model tests the <tt>Mixer</tt> model. 
<p>
Simulate for 20 s. At time t=1 the first inlet flow rate is reduced. At time t=8 the second inlet flow rate is reduced. At time t=15, the outlet valve is partially closed.
</html>"));
    end TestGasMixer;
    
    model TestCC 
      
      annotation (uses(ThermoPower(version="2"), Modelica(version="2.2")), Diagram,
        Documentation(info="<html>
This model tests the <tt>CombustionChamber</tt> model. The model start at steady state. At time t = 0.5, the fuel flow rate is reduced by 10%.

<p>Simulate for 5s. 
</html>"),
        experiment(StopTime=5));
      ThermoPower.Gas.SourceW Wcompressor(redeclare package Medium = 
            ThermoPower.Media.Air,
        w0=158,
        T=616.95) 
        annotation (extent=[-80,-10; -60,10]);
      ThermoPower.Gas.CombustionChamber CombustionChamber1(
        initOpt=ThermoPower.Choices.Init.Options.steadyState,
        HH=41.6e6,
        pstart=11.2e5,
        V=0.1,
        S=0.1)           annotation (extent=[-38,-10; -18,10]);
      ThermoPower.Gas.SourceW Wfuel(redeclare package Medium = 
            ThermoPower.Media.NaturalGas) 
        annotation (extent=[-50,28; -30,48]);
      ThermoPower.Gas.PressDrop PressDrop1(
        redeclare package Medium = ThermoPower.Media.FlueGas,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint,
        rhonom=3.3,
        wnom=158.9,
        pstart=11.2e5,
        dpnom=0.426e5)  annotation (extent=[-4,-10; 16,10]);
      ThermoPower.Gas.SensT SensT1(redeclare package Medium = 
            ThermoPower.Media.FlueGas) annotation (extent=[26,-6; 46,14]);
      Modelica.Blocks.Sources.Step Step1(
        startTime=0.5,
        height=-0.3,
        offset=3.1)    annotation (extent=[-78,56; -58,76]);
      ThermoPower.Gas.ValveLin ValveLin1(redeclare package Medium = 
            ThermoPower.Media.FlueGas, Kv=161.1/9.77e5) 
        annotation (extent=[54,-10; 74,10]);
      ThermoPower.Gas.SinkP SinkP1(redeclare package Medium = 
            ThermoPower.Media.FlueGas) annotation (extent=[84,-10; 104,10]);
      Modelica.Blocks.Sources.Constant Constant1 
        annotation (extent=[22,28; 42,48]);
    equation 
      connect(Wfuel.flange, CombustionChamber1.inf) annotation (points=[-30,38;
            -28,38; -28,10], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Wcompressor.flange, CombustionChamber1.ina) annotation (points=[-60,0;
            -38,0], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(CombustionChamber1.out, PressDrop1.inlet) 
        annotation (points=[-18,0; -4,0], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(PressDrop1.outlet, SensT1.inlet) 
        annotation (points=[16,0; 30,0], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Step1.y, Wfuel.in_w0) annotation (points=[-57,66; -46,66; -46,43], style(
            color=74, rgbcolor={0,0,127}));
      connect(ValveLin1.outlet, SinkP1.flange) annotation (points=[74,0; 84,0], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(SensT1.outlet, ValveLin1.inlet) annotation (points=[42,0; 54,0], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Constant1.y, ValveLin1.cmd) annotation (points=[43,38; 64,38; 64,7],
          style(color=74, rgbcolor={0,0,127}));
    end TestCC;
    
    model TestGasPressDrop 
      package Medium=Modelica.Media.IdealGases.MixtureGases.CombustionAir;
      Gas.SourceP SourceP1(
        redeclare package Medium = Medium,
        T=400,
        p0=5e5)      annotation (extent=[-70,10; -50,30]);
      Modelica.Blocks.Sources.Step Step1(
        startTime=2,
        height=-.3,
        offset=1)      annotation (extent=[20,40; 40,60]);
      Gas.PressDropLin PressDropLin1(redeclare package Medium = Medium, R=5.5e4) 
        annotation (extent=[6,10; 26,30]);
      Gas.SinkP SinkP1(
        redeclare package Medium = Medium,
        T=300,
        p0=3e5)    annotation (extent=[70,10; 90,30]);
      Gas.PressDrop PressDrop1(
        redeclare package Medium = Medium,
        dpnom=2e5,
        pstart=5e5,
        Tstart=400,
        rhonom=3,
        wnom=1,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint) 
                   annotation (extent=[-30,10; -10,30]);
      Gas.Valve Valve1(
        redeclare package Medium = Medium,
        dpnom=1.5e5,
        pnom=2.5e5,
        Av=20e-4,
        wnom=1,
        CvData=ThermoPower.Choices.Valve.CvTypes.Av) 
                 annotation (extent=[40,10; 60,30]);
      Modelica.Blocks.Sources.Sine Sine1(
        phase=0,
        offset=5e5,
        startTime=0.1,
        freqHz=0.2,
        amplitude=3e5) 
                     annotation (extent=[-94,40; -74,60]);
      Gas.SourceP SourceP2(
        redeclare package Medium = Medium,
        T=400,
        p0=5e5)      annotation (extent=[-70,-60; -50,-40]);
      Modelica.Blocks.Sources.Step Step2(
        startTime=2,
        height=-.3,
        offset=1)      annotation (extent=[20,-30; 40,-10]);
      Gas.PressDropLin PressDropLin2(redeclare package Medium = Medium, R=0.5e5) 
        annotation (extent=[6,-60; 26,-40]);
      Gas.SinkP SinkP2(
        redeclare package Medium = Medium,
        T=300,
        p0=3e5)    annotation (extent=[70,-60; 90,-40]);
      Gas.PressDrop PressDrop2(
        redeclare package Medium = Medium,
        dpnom=2e5,
        pstart=5e5,
        Tstart=400,
        rhonom=3,
        wnom=1,
        Kf=8e5,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.Kf) 
                   annotation (extent=[-30,-60; -10,-40]);
      Gas.Valve Valve2(
        redeclare package Medium = Medium,
        dpnom=1.5e5,
        pnom=2.5e5,
        Av=20e-4,
        wnom=1,
        CvData=ThermoPower.Choices.Valve.CvTypes.OpPoint) 
                 annotation (extent=[40,-60; 60,-40]);
      Modelica.Blocks.Sources.Sine Sine2(
        phase=0,
        startTime=0.1,
        freqHz=0.2,
        amplitude=5e5,
        offset=7e5)  annotation (extent=[-96,-32; -76,-12]);
    //initial equation 
    //Valve2.w=1;
      
    equation 
      connect(PressDrop1.outlet, PressDropLin1.inlet)     annotation (points=[-10,20;
            6,20], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(PressDrop1.inlet, SourceP1.flange)     annotation (points=[-30,20;
            -50,20], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Valve1.outlet, SinkP1.flange) annotation (points=[60,20; 70,20],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Step1.y, Valve1.theta) annotation (points=[41,50; 50,50; 50,27.2],
                     style(color=74, rgbcolor={0,0,127}));
      connect(PressDropLin1.outlet, Valve1.inlet) annotation (points=[26,20; 40,
            20], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Sine1.y, SourceP1.in_p)    annotation (points=[-73,50; -66,50; -66,
            26.4],    style(color=74, rgbcolor={0,0,127}));
      connect(PressDrop2.outlet,PressDropLin2. inlet)     annotation (points=[-10,-50;
            6,-50], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(PressDrop2.inlet,SourceP2. flange)     annotation (points=[-30,-50;
            -50,-50], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Valve2.outlet,SinkP2. flange) annotation (points=[60,-50; 70,-50],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Step2.y,Valve2. theta) annotation (points=[41,-20; 50,-20; 50,-42.8],
                     style(color=74, rgbcolor={0,0,127}));
      connect(PressDropLin2.outlet,Valve2. inlet) annotation (points=[26,-50; 40,
            -50], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Sine2.y, SourceP2.in_p)    annotation (points=[-75,-22; -66,-22;
            -66,-43.6],
                      style(color=74, rgbcolor={0,0,127}));
     annotation (Diagram, uses(Modelica(version="2.1")),
        Documentation(info="<html>
This model tests the <tt>PressDrop</tt>, <tt>PressDropLin</tt> and <tt>Valve</tt> models, testing various conditions, such as different friction coefficients in <tt>PressDrop</tt> and different flow coefficients in <tt>Valve</tt>, by setting the <tt>FFtype</tt> and <tt>CvData</tt> respectively on different value. Reverse flow conditions are also tested.
<p>Simulate for 10 seconds. At time t=2 the valve is partially closed.
</html>"));
    end TestGasPressDrop;
    
    model TestGasValveOpPoint 
      
      package Medium=Media.Air;
      Gas.SourceP SourceP1(redeclare package Medium = Medium, p0=5e5) 
        annotation (extent=[-80,10; -60,30]);
      Gas.SinkP SinkP1(redeclare package Medium = Medium, p0=2.5e5) 
        annotation (extent=[62,10; 82,30]);
      Gas.Valve Valve1(
        redeclare package Medium = Medium,
        pnom=5e5,
        dpnom=1e5,
        wnom=1,
        CvData=ThermoPower.Choices.Valve.CvTypes.OpPoint) 
                  annotation (extent=[-40,10; -20,30]);
      Gas.Valve Valve2(
        redeclare package Medium = Medium,
        pnom=4e5,
        dpnom=1.5e5,
        wnom=1,
        CheckValve=false,
        CvData=ThermoPower.Choices.Valve.CvTypes.OpPoint) 
                  annotation (extent=[10,10; 30,30]);
      annotation (Diagram, Documentation(info="<html>
This models tests the Valve model in different operating conditions. The valve flow coefficients are set by the initial operating point; this means that four additional initial equations are needed to fully specify the flow coefficients.
<p>Simulate for 4 s. The valves are partially closed at t = 0.3 and t = 0.7.
</html>"),
        experiment(StopTime=10),
        experimentSetupOutput);
      Modelica.Blocks.Sources.Sine Sine1(
        amplitude=2e5,
        offset=3.5e5,
        freqHz=.4)    annotation (extent=[40,40; 60,60]);
      Modelica.Blocks.Sources.Step Step1(
        offset=1,
        startTime=0.3,
        height=-.5)    annotation (extent=[-60,40; -40,60]);
      Modelica.Blocks.Sources.Step Step2(
        height=-.3,
        offset=1,
        startTime=0.7) annotation (extent=[-10,40; 10,60]);
      Gas.SourceP SourceP2(redeclare package Medium = Medium, p0=5e5) 
        annotation (extent=[-80,-60; -60,-40]);
      Gas.SinkP SinkP2(redeclare package Medium = Medium, p0=2.5e5) 
        annotation (extent=[62,-60; 82,-40]);
      Gas.Valve Valve3(
        redeclare package Medium = Medium,
        pnom=5e5,
        dpnom=1e5,
        wnom=1,
        CvData=ThermoPower.Choices.Valve.CvTypes.OpPoint) 
                  annotation (extent=[-40,-60; -20,-40]);
      Gas.Valve Valve4(
        redeclare package Medium = Medium,
        pnom=4e5,
        dpnom=1.5e5,
        wnom=1,
        CheckValve=true,
        CvData=ThermoPower.Choices.Valve.CvTypes.OpPoint) 
                  annotation (extent=[10,-60; 30,-40]);
      Modelica.Blocks.Sources.Sine Sine2(
        amplitude=2e5,
        offset=3.5e5,
        freqHz=.4)    annotation (extent=[40,-30; 60,-10]);
      Modelica.Blocks.Sources.Step Step3(
        offset=1,
        startTime=0.3,
        height=-.8)    annotation (extent=[-60,-30; -40,-10]);
      Modelica.Blocks.Sources.Step Step4(
        height=-.3,
        offset=1,
        startTime=0.7) annotation (extent=[-10,-30; 10,-10]);
    /*initial equation 
  Valve1.w=1;
  Valve2.Av=0.25*Valve1.Av;
  Valve3.w=1;
  Valve4.inlet.p=4e5;*/
      
    equation 
      connect(SourceP1.flange, Valve1.inlet) annotation (points=[-60,20; -40,20],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Valve1.outlet, Valve2.inlet) annotation (points=[-20,20; 10,20],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Valve2.outlet, SinkP1.flange) annotation (points=[30,20; 62,20],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Step1.y, Valve1.theta) annotation (points=[-39,50; -30,50; -30,27.2],
                             style(color=74, rgbcolor={0,0,127}));
      connect(Step2.y, Valve2.theta) annotation (points=[11,50; 20,50; 20,27.2],
                      style(color=74, rgbcolor={0,0,127}));
      connect(Sine1.y, SinkP1.in_p) annotation (points=[61,50; 66,50; 66,25.95;
            65.55,25.95], style(color=74, rgbcolor={0,0,127}));
      connect(SourceP2.flange,Valve3. inlet) annotation (points=[-60,-50; -40,-50],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Valve3.outlet,Valve4. inlet) annotation (points=[-20,-50; 10,-50],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Valve4.outlet,SinkP2. flange) annotation (points=[30,-50; 62,-50],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Step3.y, Valve3.theta) annotation (points=[-39,-20; -30,-20; -30,
            -42.8],            style(color=74, rgbcolor={0,0,127}));
      connect(Step4.y, Valve4.theta) annotation (points=[11,-20; 20,-20; 20,-42.8],
                              style(color=74, rgbcolor={0,0,127}));
      connect(Sine2.y, SinkP2.in_p) annotation (points=[61,-20; 66,-20; 66,-44.05;
            65.55,-44.05],         style(color=74, rgbcolor={0,0,127}));
    end TestGasValveOpPoint;
    
    model TestGasValve 
      package Medium=Modelica.Media.IdealGases.MixtureGases.CombustionAir;
      Gas.SourceP SourceP1(
        redeclare package Medium = Medium,
        T=500,
        p0=5e5)    annotation (extent=[-90,10; -70,30]);
      Gas.SinkP SinkP1(
        redeclare package Medium = Medium,
        T=350,
        p0=2.5e5) 
               annotation (extent=[70,10; 90,30]);
      annotation (Diagram,
        experiment(StopTime=10),
        experimentSetupOutput,
        uses(
          ThermoPower(version="2"),
          Modelica(version="2.1",
          Media(         version="0.900"))),
        Documentation(info="<html>
This model tests the <tt>Valve</tt> model, in each possible configuration, i.e. with all the <tt>CvData</tt> options except <tt>OpPoint</tt>, as well as <tt>CheckValve</tt>.

<p>Simulate for 10 s. At time t=1, t=3 and t=6 the valves are partially closed.
</html>"));
      Gas.Valve V1(
        redeclare package Medium = Medium,
        dpnom=1e5,
        wnom=0.5,
        Tstart=500,
        pnom=5e5,
        Cv=165,
        CvData=ThermoPower.Choices.Valve.CvTypes.Cv) 
                   annotation (extent=[-50,10; -30,30]);
      Modelica.Blocks.Sources.Step S2(
        offset=1,
        startTime=6,
        height=-.5)  annotation (extent=[-70,40; -50,60]);
      Gas.Valve V2(
        redeclare package Medium = Medium,
        dpnom=1e5,
        wnom=0.5,
        Tstart=500,
        pnom=4e5,
        Av=30e-4,
        CvData=ThermoPower.Choices.Valve.CvTypes.Av) 
                   annotation (extent=[-10,10; 10,30]);
      Gas.Valve V3(
        redeclare package Medium = Medium,
        wnom=0.5,
        Tstart=500,
        dpnom=0.5e5,
        pnom=3e5,
        Kv=132,
        CvData=ThermoPower.Choices.Valve.CvTypes.Kv) 
                   annotation (extent=[30,10; 50,30]);
      Modelica.Blocks.Sources.Step S3(
        offset=1,
        height=-.3,
        startTime=3) annotation (extent=[-30,40; -10,60]);
      Modelica.Blocks.Sources.Step S4(
        offset=1,
        startTime=1,
        height=-.6)  annotation (extent=[10,40; 30,60]);
      Modelica.Blocks.Sources.Sine Sine2(
        freqHz=0.5,
        offset=4e5,
        amplitude=2e5) 
                    annotation (extent=[46,40; 66,60]);
      
      Gas.SourceP SourceP2(
        redeclare package Medium = Medium,
        T=500,
        p0=5e5)    annotation (extent=[-90,-60; -70,-40]);
      Gas.SinkP SinkP2(
        redeclare package Medium = Medium,
        T=350,
        p0=2e5) 
               annotation (extent=[70,-60; 90,-40]);
      Modelica.Blocks.Sources.Step S6(
        offset=1,
        startTime=6,
        height=-.3)  annotation (extent=[-70,-30; -50,-10]);
      Gas.Valve V6(
        redeclare package Medium = Medium,
        CheckValve=false,
        Tstart=500,
        pnom=5e5,
        dpnom=1.5e5,
        Av=12e-4,
        CvData=ThermoPower.Choices.Valve.CvTypes.Av) 
                   annotation (extent=[-50,-60; -30,-40]);
      Modelica.Blocks.Sources.Step S7(
        offset=1,
        startTime=1,
        height=-.5)  annotation (extent=[-30,-30; -10,-10]);
      Modelica.Blocks.Sources.Step S8(
        offset=1,
        startTime=3,
        height=-.5)  annotation (extent=[10,-30; 30,-10]);
      Gas.Valve V7(
        redeclare package Medium = Medium,
        Tstart=500,
        dpnom=0.5e5,
        CheckValve=false,
        pnom=3.5e5,
        Kv=102,
        CvData=ThermoPower.Choices.Valve.CvTypes.Kv) 
                   annotation (extent=[-10,-60; 10,-40]);
      Gas.Valve V8(
        redeclare package Medium = Medium,
        Tstart=500,
        pnom=3e5,
        dpnom=1e5,
        Cv=122,
        CheckValve=true,
        CvData=ThermoPower.Choices.Valve.CvTypes.Cv) 
                   annotation (extent=[30,-60; 50,-40]);
      Modelica.Blocks.Sources.Sine Sine1(
        freqHz=0.5,
        amplitude=2e5,
        offset=4e5) annotation (extent=[46,-30; 66,-10]);
    equation 
      connect(S2.y,V1. theta) annotation (points=[-49,50; -40,50; -40,27.2],
                                                                          style(
            color=74, rgbcolor={0,0,127}));
      connect(V1.outlet,V2. inlet) annotation (points=[-30,20; -10,20], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(S3.y,V2. theta) annotation (points=[-9,50; 0,50; 0,27.2],   style(
            color=74, rgbcolor={0,0,127}));
      connect(S4.y,V3. theta) annotation (points=[31,50; 40,50; 40,27.2],
                   style(color=74, rgbcolor={0,0,127}));
      connect(V3.outlet, SinkP1.flange) annotation (points=[50,20; 70,20], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(V2.outlet,V3. inlet) annotation (points=[10,20; 30,20], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Sine2.y, SinkP1.in_p) annotation (points=[67,50; 74,50; 74,25.95;
            73.55,25.95], style(color=74, rgbcolor={0,0,127}));
      connect(SourceP1.flange,V1. inlet) annotation (points=[-70,20; -50,20],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(S6.y,V6. theta) annotation (points=[-49,-20; -40,-20; -40,-42.8],
                    style(color=74, rgbcolor={0,0,127}));
      connect(V6.outlet,V7. inlet) annotation (points=[-30,-50; -10,-50], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(V7.outlet,V8. inlet) annotation (points=[10,-50; 30,-50], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(V8.outlet,SinkP2. flange) annotation (points=[50,-50; 70,-50], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(S8.y,V8. theta) annotation (points=[31,-20; 40,-20; 40,-42.8],
                    style(color=74, rgbcolor={0,0,127}));
      connect(S7.y,V7. theta) annotation (points=[-9,-20; 0,-20; 0,-42.8],
                    style(color=74, rgbcolor={0,0,127}));
      connect(Sine1.y,SinkP2. in_p) annotation (points=[67,-20; 74,-20; 74,-44.05;
            73.55,-44.05],style(color=74, rgbcolor={0,0,127}));
      connect(SourceP2.flange,V6. inlet) annotation (points=[-70,-50; -50,-50],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
    end TestGasValve;
    
    model TestCompressorConstSpeed 
    package Medium=Modelica.Media.IdealGases.MixtureGases.CombustionAir;
    protected 
       parameter Real tableEta[6,4]=[0,95,100,105;
                                     1,82.5e-2,81e-2,80.5e-2;
                                     2,84e-2,82.9e-2,82e-2;
                                     3,83.2e-2,82.2e-2,81.5e-2;
                                     4,82.5e-2,81.2e-2,79e-2;
                                     5,79.5e-2,78e-2,76.5e-2];
       parameter Real tablePhic[6,4]=[0,95,100,105;
                                     1,38.3e-3,43e-3,46.8e-3;
                                     2,39.3e-3,43.8e-3,47.9e-3;
                                     3,40.6e-3,45.2e-3,48.4e-3;
                                     4,41.6e-3,46.1e-3,48.9e-3;
                                     5,42.3e-3,46.6e-3,49.3e-3];
      
       parameter Real tablePR[6,4]=[0,95,100,105;
                                    1,22.6,27,32;
                                    2,22,26.6,30.8;
                                    3,20.8,25.5,29;
                                    4,19,24.3,27.1;
                                    5,17,21.5,24.2];
      
      annotation (uses(ThermoPower(version="2"), Modelica(version="2.1")), Diagram,
        experiment(StopTime=2),
        experimentSetupOutput,
        Documentation(info="<html>
This model test the <tt>Compressor</tt> model at constant speed.

<p>Simulate for 2s.

</html>"));
    public 
      ThermoPower.Gas.SourceP SourceP1(redeclare package Medium = Medium,
        p0=0.35e5,
        T=244.4) 
        annotation (extent=[-80,6; -60,26]);
      ThermoPower.Gas.SinkP SinkP1(
        redeclare package Medium = Medium,
        p0=8.3e5,
        T=691.4) 
               annotation (extent=[40,6; 60,26]);
      ThermoPower.Gas.Compressor Compressor(
        redeclare package Medium = Medium,
        pstart_in=0.35e5,
        pstart_out=8.3e5,
        Tstart_in=244.4,
        Tstart_out=691.4,
        tablePhic=tablePhic,
        tableEta=tableEta,
        tablePR=tablePR,
        Table=ThermoPower.Choices.TurboMachinery.TableTypes.matrix,
        Ndesign=523.3,
        Tdes_in=244.4)  annotation (extent=[-20,-20; 20,20]);
      Modelica.Mechanics.Rotational.ConstantSpeed ConstantSpeed1(w_fixed=523.3) 
        annotation (extent=[-50,-10; -30,10]);
    equation 
      connect(SourceP1.flange, Compressor.inlet)     annotation (points=[-60,16;
            -16,16], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Compressor.outlet, SinkP1.flange)     annotation (points=[16,16; 40,
            16], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(ConstantSpeed1.flange, Compressor.shaft_a)     annotation (points=[-30,0;
            -30,0; -26,-0.2; -13,-0.2], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
    end TestCompressorConstSpeed;
    
    model TestCompressorInertia 
    package Medium=Modelica.Media.IdealGases.MixtureGases.CombustionAir;
      annotation (uses(ThermoPower(version="2"), Modelica(version="2.1")), Diagram,
        experiment(StopTime=2),
        experimentSetupOutput,
        Documentation(info="<html>
This model test the <tt>Compressor</tt> model with an inertial load. Boundary conditions and data refer to an turbojet engine at 11.000 m.

<p>Simulate for 2 seconds. The compressor slows down.
</html>"));
    protected 
       parameter Real tableEta[6,4]=[0,95,100,105;
                                     1,82.5e-2,81e-2,80.5e-2;
                                     2,84e-2,82.9e-2,82e-2;
                                     3,83.2e-2,82.2e-2,81.5e-2;
                                     4,82.5e-2,81.2e-2,79e-2;
                                     5,79.5e-2,78e-2,76.5e-2];
       parameter Real tablePhic[6,4]=[0,95,100,105;
                                     1,38.3e-3,43e-3,46.8e-3;
                                     2,39.3e-3,43.8e-3,47.9e-3;
                                     3,40.6e-3,45.2e-3,48.4e-3;
                                     4,41.6e-3,46.1e-3,48.9e-3;
                                     5,42.3e-3,46.6e-3,49.3e-3];
      
       parameter Real tablePR[6,4]=[0,95,100,105;
                                    1,22.6,27,32;
                                    2,22,26.6,30.8;
                                    3,20.8,25.5,29;
                                    4,19,24.3,27.1;
                                    5,17,21.5,24.2];
      
    public 
      ThermoPower.Gas.SourceP SourceP1(redeclare package Medium = Medium,
        p0=0.35e5,
        T=244.4) 
        annotation (extent=[-80,6; -60,26]);
      ThermoPower.Gas.SinkP SinkP1(
        redeclare package Medium = Medium,
        p0=8.3e5,
        T=691.4) 
               annotation (extent=[40,6; 60,26]);
      Modelica.Mechanics.Rotational.Inertia Inertia1(J=10000) 
        annotation (extent=[10,-10; 30,10]);
      ThermoPower.Gas.Compressor Compressor(
        redeclare package Medium = Medium,
        pstart_in=0.35e5,
        pstart_out=8.3e5,
        Tstart_in=244.4,
        Tstart_out=691.4,
        tablePhic=tablePhic,
        tableEta=tableEta,
        tablePR=tablePR,
        Table=ThermoPower.Choices.TurboMachinery.TableTypes.matrix,
        explicitIsentropicEnthalpy=false,
        Ndesign=523.3,
        Tdes_in=244.4)  annotation (extent=[-40,-20; 0,20]);
    initial equation 
      Inertia1.w=523.3;
      
    equation 
      connect(SourceP1.flange, Compressor.inlet)     annotation (points=[-60,16;
            -36,16], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Compressor.outlet, SinkP1.flange)     annotation (points=[-4,16; 40,
            16], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Compressor.shaft_b, Inertia1.flange_a)     annotation (points=[-7.2,
            -0.2; -7.2,-0.05; 10,-0.05; 10,0], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
    end TestCompressorInertia;
    
    model TestGasTurbine 
    package Medium=Modelica.Media.IdealGases.MixtureGases.CombustionAir;
    protected 
      parameter Real tablePhic[5,4]=[1,90,100,110;
                                     2.36,4.68e-3,4.68e-3,4.68e-3;
                                     2.88,4.68e-3,4.68e-3,4.68e-3;
                                     3.56,4.68e-3,4.68e-3,4.68e-3;
                                     4.46,4.68e-3,4.68e-3,4.68e-3];
      parameter Real tableEta[5,4]=[1,90,100,110;
                                    2.36,89e-2,89.5e-2,89.3e-2;
                                    2.88,90e-2,90.6e-2,90.5e-2;
                                    3.56,90.5e-2,90.6e-2,90.5e-2;
                                    4.46,90.2e-2,90.3e-2,90e-2];
      annotation (uses(ThermoPower(version="2"), Modelica(version="2.1")), Diagram,
        experiment(StopTime=10),
        experimentSetupOutput,
        Documentation(info="<html>
This model test the Turbine model with an inertial load. Boundary conditions and data refer to an turbojet engine at 11.000 m. 

<p>Simulate for 5 seconds.  
</html>"));
    public 
      ThermoPower.Gas.SourceP SourceP1(redeclare package Medium = Medium,
        T=1270,
        p0=7.85e5) 
        annotation (extent=[-80,6; -60,26]);
      Modelica.Mechanics.Rotational.Inertia Inertia1(J=10000) 
        annotation (extent=[10,-10; 30,10]);
      Gas.Turbine Turbine1(
        redeclare package Medium = Medium,
        tablePhic=tablePhic,
        tableEta=tableEta,
        pstart_in=7.85e5,
        pstart_out=1.52e5,
        Tstart_in=1270,
        Tstart_out=883,
        Ndesign=523.3,
        Tdes_in=1400,
        Table=ThermoPower.Choices.TurboMachinery.TableTypes.matrix) 
                           annotation (extent=[-40,-20; 0,20]);
      Gas.SinkP SinkP1(
        redeclare package Medium = Medium,
        p0=1.52e5,
        T=883) annotation (extent=[40,6; 60,26]);
    equation 
      connect(SourceP1.flange, Turbine1.inlet)    annotation (points=[-60,16; -36,
            16], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Turbine1.outlet, SinkP1.flange)    annotation (points=[-4,16; 40,16],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
    initial equation 
    Inertia1.w=523.3;
      
    equation 
      connect(Turbine1.shaft_b, Inertia1.flange_a)    annotation (points=[-5.4,
            3.55271e-016; -4,3.55271e-016; -4,0; 10,0], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
    end TestGasTurbine;
    
    model TestGasTurbineStodola 
    package Medium=Modelica.Media.IdealGases.MixtureGases.CombustionAir;
      
    protected 
      parameter Real tableEta[5,4]=[1,90,100,110;
                                    7,89e-2,89.5e-2,89.3e-2;
                                    10,90e-2,90.6e-2,90.5e-2;
                                    12,90.5e-2,90.6e-2,90.5e-2;
                                    15,90.2e-2,90.3e-2,90e-2];
        annotation (extent=[-58,20; -38,40], Diagram,
        Documentation(info="<html>
This model test the Turbine model based on the Stodola's law at constant speed. Boundary conditions and data refer to an turbojet engine at 11.000 m. 
<p>Simulate for 5 seconds. 
</html>"),
        experiment(StopTime=5));
    public 
      ThermoPower.Gas.SourceP SourceP1(redeclare package Medium = Medium,
        T=1270,
        p0=7.85e5) 
        annotation (extent=[-80,6; -60,26]);
      Modelica.Mechanics.Rotational.Inertia Inertia1(J=10000) 
        annotation (extent=[30,-10; 50,10]);
      Gas.TurbineStodola Turbine1(
        redeclare package Medium = Medium,
        pstart_in=7.85e5,
        pstart_out=1.52e5,
        Tstart_in=1270,
        Tstart_out=883,
        K=4.75e-3,
        Table=ThermoPower.Choices.TurboMachinery.TableTypes.matrix,
        tableEta=tableEta,
        fixedEta=true,
        Ndesign=523.3,
        Tdes_in=1400,
        wnom=104)          annotation (extent=[-20,-20; 20,20]);
      Gas.SinkP SinkP1(
        redeclare package Medium = Medium,
        p0=1.52e5,
        T=883) annotation (extent=[60,6; 80,26]);
      Modelica.Mechanics.Rotational.ConstantSpeed ConstantSpeed1(w_fixed=523.3) 
        annotation (extent=[-50,-10; -30,10]);
    equation 
      connect(SourceP1.flange, Turbine1.inlet)    annotation (points=[-60,16; -16,
            16], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Turbine1.outlet, SinkP1.flange)    annotation (points=[16,16; 60,16],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Turbine1.shaft_b, Inertia1.flange_a)    annotation (points=[14.6,
            3.55271e-016; 16,3.55271e-016; 16,0; 30,0], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(ConstantSpeed1.flange, Turbine1.shaft_a)    annotation (points=[-30,0;
            -14,0; -14,3.55271e-016; -14.6,3.55271e-016], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      annotation (Diagram);
    end TestGasTurbineStodola;
    
    model TestTurboJetInertia 
      parameter SpecificEnthalpy HH(fixed=false, start=40e6) 
        "Fuel lower heat value";
    protected 
       parameter Real tableEtaC[6,4]=[0,95,100,105;
                                     1,82.5e-2,81e-2,80.5e-2;
                                     2,84e-2,82.9e-2,82e-2;
                                     3,83.2e-2,82.2e-2,81.5e-2;
                                     4,82.5e-2,81.2e-2,79e-2;
                                     5,79.5e-2,78e-2,76.5e-2];
       parameter Real tablePhicC[6,4]=[0,95,100,105;
                                     1,38.3e-3,43e-3,46.8e-3;
                                     2,39.3e-3,43.8e-3,47.9e-3;
                                     3,40.6e-3,45.2e-3,48.4e-3;
                                     4,41.6e-3,46.1e-3,48.9e-3;
                                     5,42.3e-3,46.6e-3,49.3e-3];
      
       parameter Real tablePR[6,4]=[0,95,100,105;
                                    1,22.6,27,32;
                                    2,22,26.6,30.8;
                                    3,20.8,25.5,29;
                                    4,19,24.3,27.1;
                                    5,17,21.5,24.2];
       parameter Real tableEtaT[5,4]=[1,90,100,110;
                                    2.36,89e-2,89.5e-2,89.3e-2;
                                    2.88,90e-2,90.6e-2,90.5e-2;
                                    3.56,90.5e-2,90.6e-2,90.5e-2;
                                    4.46,90.2e-2,90.3e-2,90e-2];
    public 
      ThermoPower.Gas.Compressor Compressor1(
        redeclare package Medium = Media.Air,
        pstart_in=0.343e5,
        Tstart_in=244.4,
        explicitIsentropicEnthalpy=true,
        Tstart_out=600,
        pstart_out=8.29e5,
        Ndesign=523.3,
        Tdes_in=244.4,
        Table=ThermoPower.Choices.TurboMachinery.TableTypes.matrix,
        tablePhic=tablePhicC,
        tableEta=tableEtaC,
        tablePR=tablePR)                  annotation (extent=[-46,-24; -26,-4]);
      ThermoPower.Gas.TurbineStodola Turbine1(
        redeclare package Medium = Media.FlueGas,
        pstart_in=7.85e5,
        pstart_out=1.52e5,
        Tstart_out=800,
        Tstart_in=1390,
        Ndesign=523.3,
        Tdes_in=1400,
        fixedEta=false,
        wnom=104,
        Table=ThermoPower.Choices.TurboMachinery.TableTypes.matrix,
        tableEta=tableEtaT)              annotation (extent=[58,-24; 78,-4]);
      annotation (uses(ThermoPower(version="2"), Modelica(version="2.1")), Diagram,
        Documentation(info="<html>
This is the full model of a turbojet-type engine at 11.000m [1].

<p>Simulate the model for 20s. At time t = 1 the fuel flow rate is reduced by 10%; the engine slows down accordingly.
<p><b>References:</b></p>
<ol>
<li>P. P. Walsh, P. Fletcher: <i>Gas Turbine Performance</i>, 2nd ed., Oxford, Blackwell, 2004, pp. 646.
</ol> 
</html>"),
        experiment(StopTime=5));
      ThermoPower.Gas.CombustionChamber CombustionChamber1(
        gamma=1,
        Cm=1,
        pstart=8.11e5,
        V=0.05,
        S=0.05,
        Tstart=1370,
        initOpt=ThermoPower.Choices.Init.Options.steadyState,
        HH=HH) 
              annotation (extent=[8,0; 28,20]);
      ThermoPower.Gas.SourceP SourceP1(redeclare package Medium = 
            Media.Air,
        T=244.4,
        p0=0.3447e5)                     annotation (extent=[-100,-16; -80,4]);
      ThermoPower.Gas.SinkP SinkP1(
        redeclare package Medium = Media.FlueGas,
        p0=1.52e5,
        T=800) annotation (extent=[82,-16; 102,4]);
      ThermoPower.Gas.SourceW SourceW1(
        redeclare package Medium = Media.NaturalGas,
        w0=2.02,
        p0=8.11e5,
        T=300)   annotation (extent=[-20,34; 0,54]);
      Modelica.Mechanics.Rotational.Inertia Inertia1(J=50) 
        annotation (extent=[6,-24; 26,-4]);
      
      Gas.PressDrop PressDrop1(
        redeclare package Medium = Media.FlueGas,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint,
        A=1,
        pstart=8.11e5,
        dpnom=0.26e5,
        wnom=102,
        Tstart=1370,
        rhonom=2)   annotation (extent=[34,0; 54,20]);
      Gas.PressDrop PressDrop2(
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint,
        A=1,
        redeclare package Medium = Media.Air,
        wnom=100,
        Tstart=600,
        pstart=8.29e5,
        dpnom=0.18e5,
        rhonom=4.7) annotation (extent=[-20,0; 0,20]);
      
      Gas.PressDrop PressDrop3(
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint,
        A=1,
        redeclare package Medium = Media.Air,
        wnom=100,
        pstart=0.3447e5,
        Tstart=244.4,
        dpnom=170,
        rhonom=0.48) 
                    annotation (extent=[-72,-16; -52,4]);
      
      Modelica.Blocks.Sources.Step Step1(
        height=-0.2,
        offset=2.02,
        startTime=1) annotation (extent=[-60,50; -40,70]);
    equation 
      connect(SourceW1.flange, CombustionChamber1.inf)     annotation (points=[0,44; 18,
            44; 18,20], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Compressor1.shaft_b, Inertia1.flange_a)    annotation (points=[-29.6,
            -14.1; -30,-14.1; -30,-14; 6,-14], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Inertia1.flange_b, Turbine1.shaft_a)    annotation (points=[26,-14;
            60.7,-14], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(CombustionChamber1.out, PressDrop1.inlet) annotation (points=[28,10;
            34,10], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(PressDrop1.outlet, Turbine1.inlet) annotation (points=[54,10; 60,10;
            60,-6], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Compressor1.outlet, PressDrop2.inlet) annotation (points=[-28,-6;
            -28,10; -20,10], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(PressDrop2.outlet, CombustionChamber1.ina) annotation (points=[0,10; 8,
            10],        style(color=76, rgbcolor={159,159,223}));
      connect(PressDrop3.outlet, Compressor1.inlet) annotation (points=[-52,-6;
            -44,-6], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(SourceP1.flange, PressDrop3.inlet) annotation (points=[-80,-6; -72,
            -6], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Turbine1.outlet, SinkP1.flange) annotation (points=[76,-6; 82,-6],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
    initial equation 
      Inertia1.phi = 0;
      Inertia1.w = 523;
      der(Inertia1.w) = 0;
      
    equation 
      connect(Step1.y, SourceW1.in_w0) annotation (points=[-39,60; -16,60; -16,49],
          style(color=74, rgbcolor={0,0,127}));
    end TestTurboJetInertia;
    
    model TestTurboJetConstSpeed 
    protected 
      parameter Real tableEtaC[6,4]=[0,95,100,105;
                                     1,82.5e-2,81e-2,80.5e-2;
                                     2,84e-2,82.9e-2,82e-2;
                                     3,83.2e-2,82.2e-2,81.5e-2;
                                     4,82.5e-2,81.2e-2,79e-2;
                                     5,79.5e-2,78e-2,76.5e-2];
      parameter Real tablePhicC[6,4]=[0,95,100,105;
                                     1,38.3e-3,43e-3,46.8e-3;
                                     2,39.3e-3,43.8e-3,47.9e-3;
                                     3,40.6e-3,45.2e-3,48.4e-3;
                                     4,41.6e-3,46.1e-3,48.9e-3;
                                     5,42.3e-3,46.6e-3,49.3e-3];
      parameter Real tablePR[6,4]=[0,95,100,105;
                                    1,22.6,27,32;
                                    2,22,26.6,30.8;
                                    3,20.8,25.5,29;
                                    4,19,24.3,27.1;
                                    5,17,21.5,24.2];
      parameter Real tablePhicT[5,4]=[1,90,100,110;
                                     2.36,4.68e-3,4.68e-3,4.68e-3;
                                     2.88,4.68e-3,4.68e-3,4.68e-3;
                                     3.56,4.68e-3,4.68e-3,4.68e-3;
                                     4.46,4.68e-3,4.68e-3,4.68e-3];
      parameter Real tableEtaT[5,4]=[1,90,100,110;
                                    2.36,89e-2,89.5e-2,89.3e-2;
                                    2.88,90e-2,90.6e-2,90.5e-2;
                                    3.56,90.5e-2,90.6e-2,90.5e-2;
                                    4.46,90.2e-2,90.3e-2,90e-2];
    public 
      ThermoPower.Gas.Compressor Compressor1(
        redeclare package Medium = Media.Air,
        tablePhic=tablePhicC,
        tableEta=tableEtaC,
        pstart_in=0.343e5,
        pstart_out=8.3e5,
        Tstart_in=244.4,
        tablePR=tablePR,
        Table=ThermoPower.Choices.TurboMachinery.TableTypes.matrix,
        Tstart_out=600.4,
        explicitIsentropicEnthalpy=true,
        Ndesign=523.3,
        Tdes_in=244.4)                    annotation (extent=[-66,-30; -46,-10]);
      ThermoPower.Gas.Turbine Turbine1(
        redeclare package Medium = Media.FlueGas,
        pstart_in=7.85e5,
        pstart_out=1.52e5,
        tablePhic=tablePhicT,
        tableEta=tableEtaT,
        Table=ThermoPower.Choices.TurboMachinery.TableTypes.matrix,
        Tstart_out=800,
        Ndesign=523.3,
        Tdes_in=1400,
        Tstart_in=1370)                  annotation (extent=[54,-30; 74,-10]);
      
      ThermoPower.Gas.CombustionChamber CombustionChamber1(
        gamma=1,
        Cm=1,
        pstart=8.11e5,
        Tstart=1370,
        V=0.05,
        S=0.05,
        initOpt=ThermoPower.Choices.Init.Options.steadyState,
        HH=41.6e6) 
              annotation (extent=[-6,0; 14,20]);
      ThermoPower.Gas.SourceP SourceP1(redeclare package Medium = 
            Media.Air,
        p0=0.343e5,
        T=244.4)                         annotation (extent=[-100,0; -80,20]);
      ThermoPower.Gas.SinkP SinkP1(
        redeclare package Medium = Media.FlueGas,
        p0=1.52e5,
        T=800) annotation (extent=[82,0; 102,20]);
      ThermoPower.Gas.SourceW SourceW1(
        redeclare package Medium = Media.NaturalGas,
        w0=2.02,
        p0=8.11e5,
        T=300)   annotation (extent=[-30,30; -10,50]);
      Modelica.Mechanics.Rotational.Inertia Inertia1(J=50) 
        annotation (extent=[-6,-30; 14,-10]);
      Gas.PressDrop PressDrop1(
        redeclare package Medium = Media.FlueGas,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint,
        A=1,
        pstart=8.11e5,
        dpnom=0.26e5,
        wnom=102,
        Tstart=1370,
        rhonom=2)   annotation (extent=[28,0; 48,20]);
      Gas.PressDrop PressDrop2(
        pstart=8.3e5,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint,
        A=1,
        redeclare package Medium = Media.Air,
        dpnom=0.19e5,
        wnom=100,
        rhonom=4.7,
        Tstart=600) annotation (extent=[-36,0; -16,20]);
      Modelica.Mechanics.Rotational.ConstantSpeed ConstantSpeed1(w_fixed=523.33) 
        annotation (extent=[-98,-30; -78,-10]);
    equation 
      connect(SourceW1.flange, CombustionChamber1.inf)     annotation (points=[-10,40;
            4,40; 4,20], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Turbine1.outlet, SinkP1.flange)    annotation (points=[72,-12; 72,
            10; 82,10], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Compressor1.shaft_b, Inertia1.flange_a)    annotation (points=[-49.6,
            -20.1; -41.8,-20.1; -41.8,-20; -6,-20], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Inertia1.flange_b, Turbine1.shaft_a)    annotation (points=[14,-20;
            56.7,-20], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(SourceP1.flange, Compressor1.inlet)    annotation (points=[-80,10;
            -64,10; -64,-12], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(CombustionChamber1.out, PressDrop1.inlet) annotation (points=[14,10;
            28,10], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(PressDrop1.outlet, Turbine1.inlet) annotation (points=[48,10; 56,10;
            56,-12], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Compressor1.outlet, PressDrop2.inlet) annotation (points=[-48,-12;
            -48,10; -36,10], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(PressDrop2.outlet, CombustionChamber1.ina) annotation (points=[-16,10;
            -6,10], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(ConstantSpeed1.flange, Compressor1.shaft_a) annotation (points=[-78,-20;
            -64,-20; -62.5,-20.1], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
     annotation (uses(ThermoPower(version="2"), Modelica(version="2.1")), Diagram,
        experiment(StopTime=5),
        Documentation(info="<html>
This is a simplified model of a turbojet-type engine at 11.000m [1], at costant speed. 
<p>Simulate the model for 20s. At time t = 1 the fuel flow rate is reduced by 10%; the engine slows down accordingly.  
<p><b>References:</b></p>
<ol>
<li>P. P. Walsh, P. Fletcher: <i>Gas Turbine Performance</i>, 2nd ed., Oxford, Blackwell, 2004, pp. 646.
</ol> 
</html>"));
    end TestTurboJetConstSpeed;
    
    model TestGT_ISO 
      
      parameter Real tableData[8,4]=[  1.3e6,   7e6,    11.6,  18.75;
                                  1.85e6,  8.2e6,  12,    18.7;
                                  2e6,     8.5e6,  12.1,  18.65;
                                  3e6,    10.8e6,  12.7,  18.6;
                                  3.5e6,  12.1e6,  13,    18.55;
                                  4e6,    13.4e6,  13.2,  18.5;
                                  4.5e6,  14.75e6, 13.5,  18.45;
                                  4.8e6,  15.5e6,  13.6,  18.43];
     ThermoPower.Gas.GTunit_ISO GT(
        tableData=tableData,
        Table=ThermoPower.Choices.TurboMachinery.TableTypes.matrix,
        pstart=0.9735e5,
        Tstart=285.5,
        constantCompositionExhaust=true,
        HH=47.92e6)    annotation (extent=[-30,-20; 10,20]);
      ThermoPower.Gas.SourceP SourceP1(
        redeclare package Medium = ThermoPower.Media.Air,
        p0=1.011e5,
        T=288.15) 
               annotation (extent=[-90,-4; -70,16]);
      ThermoPower.Gas.SinkP SinkP1(
        redeclare package Medium = ThermoPower.Media.FlueGas,
        p0=1e5,
        T=526 + 273) 
               annotation (extent=[30,4; 50,24]);
      Modelica.Mechanics.Rotational.ConstantSpeed ConstantSpeed1(w_fixed=1819.6) 
        annotation (extent=[80,-10; 60,10]);
      ThermoPower.Gas.SourceW SourceW1(
        redeclare package Medium = ThermoPower.Media.NaturalGas,
        T=291.44,
        p0=13.27e5,
        w0=0.317) 
                 annotation (extent=[-40,24; -20,44]);
      Gas.PressDrop PressDrop1(
        redeclare package Medium = ThermoPower.Media.Air,
        pstart=1.011e5,
        Tstart=288.15,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint,
        dpnom=0.0375e5,
        rhonom=1.2,
        wnom=18.6) annotation (extent=[-60,-4; -40,16]);
      Modelica.Blocks.Sources.Step Step1(
        height=-0.1,
        offset=0.317,
        startTime=1) annotation (extent=[-70,50; -50,70]);
    equation 
      connect(SourceW1.flange, GT.Fuel_in)      annotation (points=[-20,34; -10,
            34; -10,14.4], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
     annotation (uses(ThermoPower(version="2"), Modelica(version="2.2")), Diagram,
        experiment(StopTime=2),
        Documentation(info="<html>
This model tests <tt>GTunit_ISO</tt>.

<p>Simulate for 2 s. The model start at steady state. At time t = 1, the fuel flow rate is reduced by 30%. The net power output GT.Pout goes from 4.5 MW to 2.7 MW.
</html>"));
      connect(SourceP1.flange, PressDrop1.inlet) annotation (points=[-70,6; -70,8;
            -76,6; -60,6], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(PressDrop1.outlet, GT.Air_in) annotation (points=[-40,6; -28,6],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(GT.FlueGas_out, SinkP1.flange) annotation (points=[8,6; 20,6; 20,14;
            30,14], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(GT.shaft_b, ConstantSpeed1.flange) annotation (points=[9.6,0; 60,
            0],
          style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Step1.y, SourceW1.in_w0) annotation (points=[-49,60; -36,60; -36,39],
          style(color=74, rgbcolor={0,0,127}));
    end TestGT_ISO;
    
    model TestGT 
      
      annotation (uses(ThermoPower(version="2"), Modelica(version="2.2")), Diagram,
        experiment(StopTime=2),
        Documentation(info="<html>
This model tests a simple power plant based on a <tt>GTunit</tt>.

<p>Simulate for 2 s. The plant starts at steady states, and produces approximately 5 MW of power. At time t=1 the breaker opens, and the GT unit starts accelerating, with a time constant of 10 seconds.

</html>"));
      
      parameter Real tabW[11,4]=[0,        233.15,  288.15,   313.15;
                                 0.485e6,   20.443,  18.608,   17.498;
                                 0.97e6,    20.443,  18.596,   17.483;
                                 1.455e6,   20.443,  18.584,   17.467;
                                 1.94e6,    20.443,  18.572,   17.452;
                                 2.425e6,   20.443,  18.560,   17.437;
                                 2.91e6,    20.443,  18.548,   17.421;
                                 3.395e6,   20.443,  18.536,   17.406;
                                 3.88e6,    20.443,  18.524,   17.391;
                                 4.365e6,   20.443,  18.512,   17.375;
                                 4.85e6,    20.443,  18.500,   17.360] 
        "table for wia_iso=f(ZLPout_iso,Tsync)";
      parameter Real tabPR[ 11,4]=[ 0,        233.15,   288.15,    313.15;
                                    0.485e6,   11.002,   10.766,    10.144;
                                    0.97e6,    12.084,    11.070,   10.453;
                                    1.455e6,   12.717,    11.374,   10.762;
                                    1.94e6,    13.166,    11.678,   11.070;
                                    2.425e6,   13.515,    11.981,   11.379;
                                    2.91e6,    13.799,    12.258,   11.687;
                                    3.395e6,   14.040,    12.589,   11.996;
                                    3.88e6,    14.248,    12.893,   12.305;
                                    4.365e6,   14.432,    13.196,   12.613;
                                    4.85e6,    14.597,    13.500,   12.922] 
        " table for PR=g(ZLPout_iso,Tsync)";
      parameter Real tabHI[12,4]=[  0,         233.15,     288.15,     313.15;
                                    0.7275e6,   39e6,       39e6,       39e6;
                                    0.97e6,     31.2e6,     27.36e6,    28.08e6;
                                    1.12125e6,  26.52e6,    24.32e6,    24.96e6;
                                    1.455e6,    24.18e6,    22.344e6,   22.932e6;
                                    1.94e6,     21.06e6,    19.456e6,   19.968e6;
                                    2.425e6,    19.188e6,   17.936e6,   18.408e6;
                                    2.91e6,     17.784e6,   17.024e6,   17.472e6;
                                    3.395e6,    17.16e6,    16.416e6,   16.848e6;
                                    3.88e6,     16.38e6,    15.96e6,    16.38e6;
                                    4.365e6,    16.224e6,   15.58e6,    15.99e6;
                                    4.85e6,     16.224e6,   15.2e6,     15.6e6] 
        "table for HI_iso=h(ZLPout_iso,Tsync)";
      ThermoPower.Gas.GTunit GTunit(
        pstart=0.999e5,
        HH=42.53e6,
        Tstart=280.55,
        constantCompositionExhaust=true,
        tableHI=tabHI,
        tablePR=tabPR,
        tableW=tabW,
        Table=ThermoPower.Choices.TurboMachinery.TableTypes.matrix) 
                       annotation (extent=[-72,-20; -32,20]);
      ThermoPower.Gas.SourceP SourceP1(
        redeclare package Medium = ThermoPower.Media.Air,
        p0=0.999e5,
        T=280.55) 
               annotation (extent=[-100,-4; -80,16]);
      ThermoPower.Gas.SinkP SinkP1(
        redeclare package Medium = ThermoPower.Media.FlueGas,
        p0=1e5,
        T=526 + 273) 
               annotation (extent=[-22,20; -2,40]);
      Modelica.Mechanics.Rotational.Inertia Inertia(J=1) 
        annotation (extent=[-22,-10; -2,10]);
      ThermoPower.Gas.SourceW SourceW1(
        redeclare package Medium = ThermoPower.Media.NaturalGas,
        T=291.44,
        p0=12.5e5,
        w0=0.365) 
                 annotation (extent=[-80,20; -60,40]);
      Electrical.Generator Generator(Np=2, eta=0.98) 
        annotation (extent=[32,-10; 52,10]);
      Electrical.Breaker Breaker  annotation (extent=[56,-10; 76,10]);
      Electrical.Grid Grid(Pn=1e9) 
                            annotation (extent=[80,-10; 100,10]);
      Modelica.Mechanics.Rotational.IdealGear IdealGear1(ratio=(17372/60)/25) 
        annotation (extent=[6,-10; 26,10]);
      Modelica.Blocks.Sources.BooleanStep BooleanStep1(startTime=1, startValue=true) 
        annotation (extent=[40,20; 60,40]);
    equation 
      connect(SourceW1.flange, GTunit.Fuel_in)  annotation (points=[-60,30; -52,
            30; -52,14.4], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(SourceP1.flange, GTunit.Air_in)  annotation (points=[-80,6; -70,6],
          style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(GTunit.FlueGas_out, SinkP1.flange)  annotation (points=[-34,6;
            -27.6,6; -27.6,30; -22,30], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Generator.powerConnection, Breaker.connection1) 
        annotation (points=[50.6,1.77636e-016; 54,0; 56,3.55272e-016; 56,
            1.77636e-016; 57.4,1.77636e-016],  style(pattern=0, thickness=2));
      connect(Breaker.connection2, Grid.connection) 
        annotation (points=[74.6,1.77636e-016; 78,0; 80,3.55272e-016; 80,
            1.77636e-016; 81.4,1.77636e-016],  style(pattern=0, thickness=2));
      connect(GTunit.shaft_b, Inertia.flange_a)   annotation (points=[-32.4,0;
            -22,0], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Inertia.flange_b, IdealGear1.flange_a) 
        annotation (points=[-2,0; 6,0], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(IdealGear1.flange_b, Generator.shaft) 
        annotation (points=[26,0; 30,0; 30,1.77636e-016; 33.4,1.77636e-016],
          style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BooleanStep1.y, Breaker.closed)  annotation (points=[61,30; 66,30;
            66,8],
                 style(color=5, rgbcolor={255,0,255}));
    initial equation 
      Inertia.phi = 0;
      der(Inertia.w) = 0;
      
    end TestGT;
    
    model TestFanMech 
      
      Gas.FanMech FanMech1(redeclare package Medium = 
            Modelica.Media.Air.SimpleAir,
        rho0=1.23,
        n0=590,
        pin_start=1e5,
        bladePos0=0.8,
        pout_start=1e5 + 5000,
        q_single_start=0,
        redeclare function flowCharacteristic = flowChar) 
                          annotation (extent=[-70,-24; -30,16]);
      Gas.SinkP SinkP1(redeclare package Medium = Modelica.Media.Air.SimpleAir)
        annotation (extent=[0,20; 20,40]);
      Gas.SourceP SourceP1(redeclare package Medium = 
            Modelica.Media.Air.SimpleAir) annotation (extent=[-98,-10; -78,10]);
      annotation (
        Diagram,
        experiment(StopTime=50, Algorithm="Dassl"),
        experimentSetupOutput(equdistant=false));
      Modelica.Mechanics.Rotational.ConstantSpeed ConstantSpeed1(w_fixed=
            Modelica.SIunits.Conversions.from_rpm(590)) 
        annotation (extent=[90,-10; 70,10]);
      function flowChar = Functions.FanCharacteristics.quadraticFlowBlades (
        bladePos_nom={0.30, 0.35, 0.40, 0.45, 0.50, 0.55, 0.60, 0.65, 0.70, 0.75, 0.80, 0.85},
        q_nom =      [   0,    0,  100,  300,  470,  620,  760,  900, 1000, 1100, 1300, 1500;
                        70,  125,  310,  470,  640,  820, 1000, 1200, 1400, 1570, 1700, 1900;
                       100,  200,  370,  530,  700,  900, 1100, 1300, 1500, 1750, 2000, 2300],
        H_nom =      [3100, 3800, 3700, 3850, 4200, 4350, 4700, 4900, 5300, 5600, 5850, 6200;
                      2000, 3000, 3000, 3000, 3000, 3200, 3200, 3300, 3600, 4200, 5000, 5500;
                      1000, 2000, 2000, 2000, 2000, 1750, 1750, 2000, 2350, 2500, 2850, 3200]);
      Modelica.Blocks.Sources.Ramp Ramp1(
        startTime=1,
        height=0.55,
        duration=9,
        offset=0.30) annotation (extent=[-100,40; -80,60]);
      Modelica.Blocks.Sources.Step Step1(
        startTime=15,
        height=-1,
        offset=1) annotation (extent=[-30,54; -10,74]);
      Modelica.Mechanics.Rotational.Inertia Inertia1(w(start=Modelica.SIunits.Conversions.from_rpm(590)),
          J=10000) annotation (extent=[-20,-10; 0,10]);
      Gas.PressDrop PressDrop1(
        wnom=2000*1.229,
        FFtype=ThermoPower.Choices.PressDrop.FFtypes.OpPoint,
        dpnom=6000,
        rhonom=1.229,
        redeclare package Medium = Modelica.Media.Air.SimpleAir) 
        annotation (extent=[-30,20; -10,40]);
      Modelica.Mechanics.Rotational.Clutch Clutch1(fn_max=1e6) 
        annotation (extent=[30,-10; 50,10]);
    equation 
      connect(SourceP1.flange, FanMech1.infl) annotation (points=[-78,0; -78,
            0.4; -66,0.4], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Ramp1.y, FanMech1.in_bladePos) annotation (points=[-79,50; -58,50;
            -58,11.2],   style(color=74, rgbcolor={0,0,127}));
      connect(FanMech1.MechPort, Inertia1.flange_a) annotation (points=[-31.4,
            0.2; -26.425,0.2; -26.425,0; -20,0], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(PressDrop1.outlet, SinkP1.flange) annotation (points=[-10,30; 0,30], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(FanMech1.outfl, PressDrop1.inlet) annotation (points=[-38,10.4;
            -40.4,10.4; -40.4,30; -30,30], style(
          color=76,
          rgbcolor={159,159,223},
          thickness=2));
      connect(Inertia1.flange_b, Clutch1.flange_a) 
        annotation (points=[0,0; 30,0], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Clutch1.flange_b, ConstantSpeed1.flange) 
        annotation (points=[50,0; 70,0], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Step1.y, Clutch1.f_normalized) annotation (points=[-9,64; 40,64; 40,
            11],style(color=74, rgbcolor={0,0,127}));
    end TestFanMech;
  end GasElements;
  
  package ElectricalElements "Test for Electrical package elements" 
    model TestElectrical1 
      parameter Power Pn=10e6 "Nominal generator power";
      parameter Time Ta=10 "Turbine acceleration time";
      parameter Integer Np=2 "Number of generator poles";
      parameter Frequency f0=50 "Nominal network frequency";
      parameter AngularVelocity omegan_el=2*pi*f0 
        "Nominal electrical angular velocity";
      parameter AngularVelocity omegan_m=omegan_el/Np 
        "Nominal mechanical angular velocity";
      parameter MomentOfInertia Je=Pn*Ta/omegan_el^2 
        "Moment of inertia referred to electrical angles";
      parameter MomentOfInertia Jm=Np^2*Je "Mechanical moment of inertia";
      parameter Time Topen=10 "Time of breaker opening";
      Electrical.Generator generator annotation (extent=[20,-10; 40,10]);
      Electrical.Load load(Wn=Pn) 
                            annotation (extent=[50,-20; 70,0],rotation=0);
      annotation (Diagram,
        experiment(StopTime=2),
        Documentation(info="<html>
<p>The model is designed to test the generator and load components of the <tt>Electrical</tt> library.<br>
Simulation sequence:
<ul>
    <li>t=0 s: The system starts at equilibrium
    <li>t=1 s: The torque is brought to zero.
    <li>t=2 s: After 10% of the turbine acceleration time, the frequency has dropped by around 10%. The approximation is due to nonlinear effects.
</ul>
<p>
Simulation Interval = [0...2] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</html>", revisions="<html>
<ul>
        <li><i>21 Jul 2004</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
        First release.</li>
</ul>
</html>
"));
      Modelica.Mechanics.Rotational.Inertia turboGenInertia(J=Jm) 
        annotation (extent=[-10,-10; 10,10]);
      Modelica.Mechanics.Rotational.Torque primeMover 
        annotation (extent=[-40,-10; -20,10]);
      import Modelica.Constants.*;
      
      Modelica.Blocks.Sources.Step Step1(
        height=-Pn/omegan_m,
        offset=Pn/omegan_m,
        startTime=1)          annotation (extent=[-80,-10; -60,10]);
    equation 
      connect(generator.powerConnection, load.connection)  annotation (points=[38.6,
            1.77636e-016; 60,1.77636e-016; 60,-1.4],  style(pattern=0,
            thickness=2));
      connect(turboGenInertia.flange_b, generator.shaft) annotation (points=[10,0; 16,
            0; 16,1.77636e-016; 21.4,1.77636e-016], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(primeMover.flange_b, turboGenInertia.flange_a) 
        annotation (points=[-20,0; -10,0], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
    initial equation 
      load.f=50;
      
    equation 
      connect(Step1.y, primeMover.tau) 
        annotation (points=[-59,0; -42,0], style(color=74, rgbcolor={0,0,127}));
    end TestElectrical1;
    
    model TestElectrical2 
      parameter Power Pn=10e6 "Nominal generator power";
      parameter Time Ta=10 "Turbine acceleration time";
      parameter Integer Np=2 "Number of generator poles";
      parameter Frequency f0=50 "Nominal network frequency";
      parameter AngularVelocity omegan_el=2*pi*f0 
        "Nominal electrical angular velocity";
      parameter AngularVelocity omegan_m=omegan_el/Np 
        "Nominal mechanical angular velocity";
      parameter MomentOfInertia Je=Pn*Ta/omegan_el^2 
        "Moment of inertia referred to electrical angles";
      parameter MomentOfInertia Jm=Np^2*Je "Mechanical moment of inertia";
      parameter Time Topen=10 "Time of breaker opening";
      Electrical.Generator generator annotation (extent=[10,-10; 30,10]);
      Electrical.Load load(Wn=Pn) annotation (extent=[30,-40; 50,-20],
                                                                    rotation=0);
      annotation (Diagram,
        experiment(StopTime=4, Tolerance=1e-009),
        Documentation(info="<html>
<p>The model is designed to test the generator and load components of the <tt>Electrical</tt> library.<br>
Simulation sequence:
<ul>
    <li>t=0 s: The system starts at equilibrium
    <li>t=1 s: The torque is brought to zero.
    <li>t=2 s: After 10% of the turbine acceleration time, the frequency has dropped by around 10%. The approximation is due to nonlinear effects.
</ul>
<p>
Simulation Interval = [0...2] sec <br> 
Integration Algorithm = DASSL <br>
Algorithm Tolerance = 1e-6 
</p>
</html>", revisions="<html>
<ul>
        <li><i>21 Jul 2004</i> by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
        First release.</li>
</ul>
</html>
"));
      Modelica.Mechanics.Rotational.Inertia turboGenInertia(J=Jm) 
        annotation (extent=[-20,-10; 0,10]);
      Modelica.Mechanics.Rotational.Torque primeMover 
        annotation (extent=[-58,-10; -38,10]);
      import Modelica.Constants.*;
      
      Modelica.Blocks.Sources.Step GenTorque(
        height=-0.1*Pn/omegan_m,
        offset=Pn/omegan_m,
        startTime=1)          annotation (extent=[-92,-10; -72,10]);
      Electrical.Grid grid(Pn=1e9) annotation (extent=[76,-10; 96,10]);
      Electrical.Breaker Breaker1 annotation (extent=[50,-10; 70,10]);
      Modelica.Blocks.Sources.Step LocalLoad(
        height=0.1*Pn,
        offset=Pn,
        startTime=2)          annotation (extent=[0,-40; 20,-20]);
      Modelica.Blocks.Sources.BooleanStep BreakerCommand(startTime=3,
          startValue=true)   annotation (extent=[20,20; 40,40]);
    equation 
      connect(turboGenInertia.flange_b, generator.shaft) annotation (points=[0,0; 4,0; 
            4,1.77636e-016; 11.4,1.77636e-016], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(primeMover.flange_b, turboGenInertia.flange_a) 
        annotation (points=[-38,0; -20,0], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Breaker1.connection2, grid.connection) annotation (points=[68.6,
            1.77636e-016; 70.8,1.77636e-016; 70.8,1.77636e-016; 73,1.77636e-016; 
            73,1.77636e-016; 77.4,1.77636e-016],
                                        style(pattern=0, thickness=2));
    initial equation 
     load.f=50;
      
    equation 
      connect(BreakerCommand.y,       Breaker1.closed) annotation (points=[41,30;
            60,30; 60,8],      style(color=5, rgbcolor={255,0,255}));
      connect(generator.powerConnection, Breaker1.connection1) annotation (points=[28.6,
            1.77636e-016; 40,-3.1606e-022; 38,0; 51.4,1.77636e-016],      style(
            pattern=0, thickness=2));
      connect(load.connection, generator.powerConnection) annotation (points=[40,-21.4; 
            40,1.77636e-016; 28.6,1.77636e-016],        style(pattern=0,
            thickness=2));
      connect(LocalLoad.y, load.powerConsumption) annotation (points=[21,-30;
            36.7,-30], style(color=74, rgbcolor={0,0,127}));
      connect(GenTorque.y, primeMover.tau) 
        annotation (points=[-71,0; -60,0], style(color=74, rgbcolor={0,0,127}));
    end TestElectrical2;
    
    model TestNetworkGridGenerator_Pmax 
      
      Electrical.Generator gen(J=10000, initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                       annotation (extent=[-10,-10; 10,10]);
      ThermoPower.Electrical.NetworkGrid_Pmax network(
        J=10000,
        Pmax=20e6,
        hasBreaker=true,
        deltaStart=0.488,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
        annotation (extent=[40,-10; 60,10]);
      annotation (Diagram, experiment(StopTime=40, Tolerance=1e-006), 
        Documentation(info="<html>
<p>The model is designed to test the <tt>NetworkGrid</tt> model.
<p>The model starts at steady state.
<p>At 20s, step variation of the tourque supplied to the generator. Observe the electric power oscillations.
</html>", revisions="<html>
<ul>
<li><i>15 Jul 2008</i>
    by <a> Luca Savoldelli </a>:<br>
       First release.</li>
</ul>
</html>"));
      Modelica.Mechanics.Rotational.TorqueStep constantTorque(
        offsetTorque=1e7/157.08, 
        stepTorque=1e7/157.08*0.2, 
        startTime=20) 
                   annotation (extent=[-78,-10; -58,10]);
      Modelica.Blocks.Sources.BooleanConstant booleanConstant(k=true) 
        annotation (extent=[12,20; 32,40]);
      Modelica.Mechanics.Rotational.Damper damper(d=25) 
        annotation (extent=[-10,-40; 10,-20]);
      Modelica.Mechanics.Rotational.Fixed fixed 
        annotation (extent=[20,-50; 40,-30]);
      Modelica.Mechanics.Rotational.Inertia inertia(J=1, w_start=157.08) 
        annotation (extent=[-48,-10; -28,10]);
    equation 
      connect(fixed.flange_b,damper. flange_b) annotation (points=[30,-40; 30,-30;
            10,-30],      style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(inertia.flange_a, constantTorque.flange) annotation (points=[-48,0;
            -58,0],      style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(gen.shaft, inertia.flange_b) annotation (points=[-8.6,
            1.77636e-016; -18,1.77636e-016; -18,0; -28,0],
          style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(damper.flange_a, inertia.flange_b) annotation (points=[-10,-30; -22,
            -30; -22,0; -28,0],       style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(network.powerConnection, gen.powerConnection) 
        annotation (points=[40,1.77636e-016; 32,0; 24,3.55272e-016; 24,
            1.77636e-016; 8.6,1.77636e-016],  style(pattern=0, thickness=2));
      connect(network.closed, booleanConstant.y) annotation (points=[50,9.7; 50,
            30; 33,30], style(color=5, rgbcolor={255,0,255}));
    end TestNetworkGridGenerator_Pmax;
    
    model TestNetworkTwoGenerators_Pmax 
      
      ThermoPower.Electrical.NetworkTwoGenerators_Pmax network(
        J_a=10000,
        J_b=10000,
        r_b=0.3,
        Pmax=40e6,
        hasBreaker=true,
        deltaStart_ab=0.0375) 
                            annotation (extent=[-10,-10; 10,10]);
      Electrical.Generator gen_a(J=10000) 
                       annotation (extent=[-44,-10; -24,10]);
      Electrical.Generator gen_b(J=10000) 
                       annotation (extent=[24,-10; 44,10],
                                                         rotation=180);
      ThermoPower.Electrical.Load load_a(
                             Wn=10e6) 
                                    annotation (extent=[-26,-38; -6,-18]);
      ThermoPower.Electrical.Load load_b(
                             Wn=10e6) 
                                    annotation (extent=[8,-38; 28,-18]);
      annotation (Diagram, experiment(StopTime=100, Tolerance=1e-006), 
        Documentation(info="<html>
<p>The model is designed to test the <tt>NetworkTwoGenerators</tt> model.
<p>At 20s, step variation of the load of a generator. Observe the electric power oscillations.
</html>", revisions="<html>
<ul>
<li><i>15 Jul 2008</i>
    by <a> Luca Savoldelli </a>:<br>
       First release.</li>
</ul>
</html>"));
      Modelica.Mechanics.Rotational.Torque torque_a 
        annotation (extent=[-72,-10; -52,10]);
      Modelica.Mechanics.Rotational.Torque torque_b 
        annotation (extent=[74,-10; 54,10], rotation=0);
      Modelica.Blocks.Sources.Step NomTorque_a(height=0, offset=1e7/157) 
        annotation (extent=[-96,-6; -84,6]);
      Modelica.Blocks.Sources.Step NomTorque_b(height=0, offset=1e7/157) 
        annotation (extent=[98,-6; 86,6]);
      Modelica.Blocks.Sources.Step step_a(
        offset=7e6,
        height=8e6, 
        startTime=20) 
                    annotation (extent=[-46,-34; -34,-22]);
      Modelica.Blocks.Sources.BooleanStep booleanConstant(
          startValue=false, startTime=0) 
        annotation (extent=[-40,40; -20,60]);
    equation 
      connect(gen_b.powerConnection, network.powerConnection_b) 
        annotation (points=[25.4,8.75526e-016; 18,8.75526e-016; 18,1.77636e-016; 
            10,1.77636e-016],                 style(pattern=0, thickness=2));
      connect(network.powerConnection_a, gen_a.powerConnection) 
                                                               annotation (
          points=[-10,1.77636e-016; -14,1.77636e-016; -14,0; -18,0; -18,
            1.77636e-016; -25.4,1.77636e-016],
                                       style(pattern=0, thickness=2));
      connect(load_a.connection, gen_a.powerConnection) 
                                                    annotation (points=[-16,
            -19.4; -16,-19.4; -16,0; -20,0; -20,1.77636e-016; -25.4,
            1.77636e-016],                   style(pattern=0, thickness=2));
      connect(load_b.connection, gen_b.powerConnection) 
                                                      annotation (points=[18,-19.4; 
            18,8.75526e-016; 25.4,8.75526e-016],     style(pattern=0, thickness=
             2));
      connect(step_a.y, load_a.powerConsumption) 
                                               annotation (points=[-33.4,-28;
            -19.3,-28], style(color=74, rgbcolor={0,0,127}));
      connect(NomTorque_b.y, torque_b.tau) annotation (points=[85.4,0; 76,0],
          style(color=74, rgbcolor={0,0,127}));
      connect(NomTorque_a.y, torque_a.tau) annotation (points=[-83.4,0; -74,0],
          style(color=74, rgbcolor={0,0,127}));
      connect(torque_b.flange_b, gen_b.shaft) annotation (points=[54,0; 48,0; 
            48,-1.2308e-015; 42.6,-1.2308e-015],
                                              style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(torque_a.flange_b, gen_a.shaft) annotation (points=[-52,0; -47.3,
            0; -47.3,1.77636e-016; -42.6,1.77636e-016],
                                                     style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(booleanConstant.y, network.closed) annotation (points=[-19,50; 0,
            50; 0,9.7],
                    style(
          color=5,
          rgbcolor={255,0,255},
          fillColor=7,
          rgbfillColor={255,255,255},
          fillPattern=1));
    end TestNetworkTwoGenerators_Pmax;
    
    model TestNetworkGridTwoGenerators 
      
      ThermoPower.Electrical.NetworkGridTwoGenerators network(
        J_a=10000,
        J_b=10000,
        r_b=0.3,
        v=15000,
        Xline=1.625,
        e_a=15000,
        e_b=15000,
        X_a=4,
        X_b=4,
        hasBreaker=false,
        initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                            annotation (extent=[-10,-10; 10,10]);
      Electrical.Generator gen_a(J=10000, initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                       annotation (extent=[-40,-10; -20,10]);
      Electrical.Generator gen_b(J=10000, initOpt=ThermoPower.Choices.Init.Options.steadyState) 
                       annotation (extent=[20,-10; 40,10],
                                                         rotation=180);
      annotation (Diagram, experiment(StopTime=40, Tolerance=1e-006), 
        Documentation(info="<html>
<p>The model is designed to test the <tt>NetworkGridtwoGenerators</tt> model.
<p>The model starts at steady state.
<p>At 20s, step variation of the tourque supplied to a generator. Observe the electric power oscillations.
</html>", revisions="<html>
<ul>
<li><i>15 Jul 2008</i>
    by <a> Luca Savoldelli </a>:<br>
       First release.</li>
</ul>
</html>"));
      Modelica.Mechanics.Rotational.Torque torque_a 
        annotation (extent=[-70,-10; -50,10]);
      Modelica.Mechanics.Rotational.Torque torque_b 
        annotation (extent=[70,-10; 50,10], rotation=0);
      Modelica.Blocks.Sources.Step NomTorque_a(          offset=1e7/157, 
        startTime=20, 
        height=1e7/157*0.2) 
        annotation (extent=[-96,-6; -84,6]);
      Modelica.Blocks.Sources.Step NomTorque_b(height=0, offset=1e7/157) 
        annotation (extent=[96,-6; 84,6]);
    equation 
      connect(gen_b.powerConnection, network.powerConnection_b) 
        annotation (points=[21.4,8.75526e-016; 18,8.75526e-016; 18,1.77636e-016; 
            10,1.77636e-016],                 style(pattern=0, thickness=2));
      connect(network.powerConnection_a, gen_a.powerConnection) 
                                                               annotation (
          points=[-10,1.77636e-016; -8,1.77636e-016; -14,0; -18,0; -18,
            1.77636e-016; -21.4,1.77636e-016],
                                       style(pattern=0, thickness=2));
      connect(NomTorque_b.y, torque_b.tau) annotation (points=[83.4,0; 72,0],
          style(color=74, rgbcolor={0,0,127}));
      connect(NomTorque_a.y, torque_a.tau) annotation (points=[-83.4,0; -72,0],
          style(color=74, rgbcolor={0,0,127}));
      connect(torque_b.flange_b, gen_b.shaft) annotation (points=[50,0; 48,0; 
            48,-1.2308e-015; 38.6,-1.2308e-015],
                                              style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(torque_a.flange_b, gen_a.shaft) annotation (points=[-50,0; -47.3,
            0; -47.3,1.77636e-016; -38.6,1.77636e-016],
                                                     style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
    end TestNetworkGridTwoGenerators;
    
    model StaticController 
      parameter Real droop "Droop";
      parameter Real PVnom=157.08 "Nominal value of process variable";
      parameter Real CVnom "Nominal value of control variable";
      Real e "error";
      Real deltaCV;
      Modelica.Blocks.Interfaces.RealInput PV 
        annotation (extent=[-120,-20; -80,20]);
      Modelica.Blocks.Interfaces.RealOutput CV 
        annotation (extent=[80,-10; 100,10]);
      annotation (Diagram, Icon(Rectangle(extent=[-80,80; 80,-80], style(
              color=3,
              rgbcolor={0,0,255},
              fillColor=7,
              rgbfillColor={255,255,255})), Text(
            extent=[-60,60; 60,-60],
            style(color=0, rgbcolor={0,0,0}),
            string="C")), 
        Documentation(info="<html>
<p>Controller for static control of the frequency.
</html>", revisions="<html>
<ul>
<li><i>15 Jul 2008</i>
    by <a> Luca Savoldelli </a>:<br>
       First release.</li>
</ul>
</html>"));
      Modelica.Blocks.Interfaces.RealInput SP 
        annotation (extent=[-20,80; 20,120], rotation=270);
    equation 
      e=(SP-PVnom)/PVnom-(PV-PVnom)/PVnom;
      deltaCV = 1/droop*e*CVnom;
      CV = deltaCV + CVnom;
    end StaticController;
    
    model TestN2GControl 
      "Test network with two generators, frequency controlled" 
      
      ThermoPower.Electrical.NetworkTwoGenerators_Pmax network(
        J_a=10000,
        J_b=10000,
        r_b=0.3,
        Pmax=20e6,
        deltaStart_ab=0.05) annotation (extent=[-10,-70; 10,-50]);
      Electrical.Generator gen_a(J=10000) 
                       annotation (extent=[-50,-70; -30,-50]);
      Electrical.Generator gen_b(J=10000) 
                       annotation (extent=[30,-70; 50,-50],
                                                         rotation=180);
      ThermoPower.Electrical.Load load_a(
                             Wn=10e6) 
                                    annotation (extent=[-30,-90; -10,-70]);
      ThermoPower.Electrical.Load load_b(
                             Wn=10e6) 
                                    annotation (extent=[10,-90; 30,-70]);
      annotation (Diagram, experiment(StopTime=100, Tolerance=1e-006), 
        Documentation(info="<html>
<p>At 20s, step variation of the load of a generator. Observe the electric power oscillations and the controlled angular velocity.
</html>", revisions="<html>
<ul>
<li><i>15 Jul 2008</i>
    by <a> Luca Savoldelli </a>:<br>
       First release.</li>
</ul>
</html>"));
      Modelica.Mechanics.Rotational.Sensors.SpeedSensor omegaSensor_a 
        annotation (extent=[-36,-8; -20,8]);
      Modelica.Mechanics.Rotational.Sensors.SpeedSensor omegaSensor_b 
        annotation (extent=[20,8; 36,-8],  rotation=180);
      Modelica.Mechanics.Rotational.Torque torque_a 
        annotation (extent=[-80,-70; -60,-50]);
      Modelica.Mechanics.Rotational.Torque torque_b 
        annotation (extent=[86,-70; 66,-50],rotation=0);
      ThermoPower.Test.ElectricalElements.StaticController controller_A(
                                   droop=0.05, CVnom=1e7/157.08) 
        annotation (extent=[-40,20; -60,40]);
      ThermoPower.Test.ElectricalElements.StaticController controller_b(
                                   droop=0.05, CVnom=1e7/157.08) 
        annotation (extent=[40,20; 60,40]);
      Modelica.Blocks.Sources.Step step_a(
        startTime=50,
        offset=8e6,
        height=5e6) annotation (extent=[-56,-86; -44,-74]);
      Modelica.Blocks.Sources.Constant SP_omega(k=157.08) 
        annotation (extent=[-36,74; -24,86],
                                          rotation=0);
      Modelica.Blocks.Continuous.FirstOrder firstOrder_a(T=1, y_start=1e7/157.08) 
        annotation (extent=[-72,22; -88,38]);
      Modelica.Blocks.Continuous.FirstOrder firstOrder_b(y_start=1e7/157.08) 
        annotation (extent=[72,22; 88,38]);
    equation 
      connect(gen_b.powerConnection, network.powerConnection_b) 
        annotation (points=[31.4,-60; 10,-60],style(pattern=0, thickness=2));
      connect(network.powerConnection_a, gen_a.powerConnection) 
                                                               annotation (
          points=[-10,-60; -31.4,-60], style(pattern=0, thickness=2));
      connect(load_a.connection, gen_a.powerConnection) 
                                                    annotation (points=[-20,-71.4;
            -20,-71.4; -20,-60; -31.4,-60],  style(pattern=0, thickness=2));
      connect(load_b.connection, gen_b.powerConnection) 
                                                      annotation (points=[20,-71.4;
            20,-60; 31.4,-60],                       style(pattern=0, thickness=
             2));
      connect(omegaSensor_a.flange_a,torque_a. flange_b) 
                                                     annotation (points=[-36,0;
            -54,0; -54,-60; -60,-60],
                                   style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(torque_b.flange_b,omegaSensor_b. flange_a) 
                                                      annotation (points=[66,-60; 
            58,-60; 58,9.79685e-016; 36,9.79685e-016],
                                 style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(controller_A.PV,omegaSensor_a. w) 
                                           annotation (points=[-40,30; -10,30;
            -10,0; -19.2,0],  style(color=74, rgbcolor={0,0,127}));
      connect(omegaSensor_b.w,controller_b. PV) 
                                           annotation (points=[19.2,
            -1.07765e-015; 10,-1.07765e-015; 10,30; 40,30],
                        style(color=74, rgbcolor={0,0,127}));
      connect(step_a.y, load_a.powerConsumption) 
                                               annotation (points=[-43.4,-80;
            -23.3,-80], style(color=74, rgbcolor={0,0,127}));
      connect(SP_omega.y, controller_b.SP) annotation (points=[-23.4,80; 0,80; 0,
            60; 50,60; 50,40],
                    style(color=74, rgbcolor={0,0,127}));
      connect(controller_A.SP, SP_omega.y) annotation (points=[-50,40; -50,60; 0,
            60; 0,80; -23.4,80],    style(color=74, rgbcolor={0,0,127}));
      connect(controller_A.CV, firstOrder_a.u) annotation (points=[-59,30; -70.4,
            30],       style(color=74, rgbcolor={0,0,127}));
      connect(firstOrder_a.y, torque_a.tau) annotation (points=[-88.8,30; -96,30;
            -96,-60; -82,-60],     style(color=74, rgbcolor={0,0,127}));
      connect(firstOrder_b.u, controller_b.CV) annotation (points=[70.4,30; 59,30],
                 style(color=74, rgbcolor={0,0,127}));
      connect(torque_b.tau, firstOrder_b.y) annotation (points=[88,-60; 96,-60;
            96,30; 88.8,30], style(color=74, rgbcolor={0,0,127}));
      connect(gen_a.shaft, torque_a.flange_b) annotation (points=[-48.6,-60; -60,
            -60], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(gen_b.shaft, torque_b.flange_b) annotation (points=[48.6,-60; 66,
            -60], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
    end TestN2GControl;
  end ElectricalElements;
end Test;
