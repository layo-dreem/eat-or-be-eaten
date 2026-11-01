using Godot;
using System;
using EatorbeEaten.Script;
using Godot.Collections;

public partial class MouseManager : Node3D
{
	public Mouse Mouse = null!;
	public MousePoint[] Positions = new MousePoint[4];
	private Timer _timer = null!;
	
	public override void _Ready()
	{
		Mouse = GetNode<Mouse>("Mouse");
		_timer = GetNode<Timer>("Timer");
		_timer.Timeout += Timer_OnTimeout;
		InitMousePoints();
		_timer.Start();
	}

	private void Timer_OnTimeout()
	{
		int rnd = Random.Shared.Next(0, 4);
		Mouse.Target = Positions[(rnd + 1) % Positions.Length];
		Console.WriteLine(rnd);
		Mouse.GlobalPosition =  Positions[rnd].GlobalPosition;
	}

	private void InitMousePoints()
	{
		int i = 0;
		Array<Node> positionNodes = GetNode<Node3D>("MousePoints").GetChildren();
		foreach (var positionNode in positionNodes)
		{
			if (positionNode is MousePoint point)
			{
				Positions[i] = point;
				point.BodyEntered += body =>
				{
					int index = Positions.IndexOf(point);
					if (body is Mouse mouse && mouse.Target == point)
					{
						mouse.Target = null;
						_timer.WaitTime = Random.Shared.Next(7, 16);
						_timer.Start();
					}
				};
			}
			i++;
		}
	}

	public override void _Process(double delta)
	{
	}
}
