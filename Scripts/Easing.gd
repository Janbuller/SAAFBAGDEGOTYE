static func easeInOutSine(x):
	return -(cos(PI * x) - 1) / 2;

static func easeInOutCubic(x):
	return 4 * x * x * x if x < 0.5 else 1 - pow(-2 * x + 2, 3) / 2
	
static func easeOutBounce(x):
	var n1 = 7.5625;
	var d1 = 2.75;

	if (x < 1 / d1):
		return n1 * x * x;
	elif (x < 2 / d1):
		x -= 1.5 / d1
		return n1 * (x) * x + 0.75;
	elif (x < 2.5 / d1):
		x -= 2.25 / d1
		return n1 * (x) * x + 0.9375;
	else:
		x -= 2.625 / d1
		return n1 * (x) * x + 0.984375;

static func easeInOutBounce(x):
	return (1 - easeOutBounce(1 - 2 * x)) / 2 if x < 0.5 else (1 + easeOutBounce(2 * x - 1)) / 2;

static func easeInOutBack(x):
	var c1 = 1.70158;
	var c2 = c1 * 1.525;

	return (pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2 if x < 0.5 else (pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2;

static func easeInOutQuad(x):
	return 2 * x * x if x < 0.5 else 1 - pow(-2 * x + 2, 2) / 2;
