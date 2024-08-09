-- Iterable Functions Classes

-- TODO

sin =(x, y)->
	math.sin(x), math.sin(y)
sphere =(x, y)->
	fac = (1/(math.sqrt((x*x)+(y*y))))
	return (fac*x), (fac*y)
swirl =(x, y)->
	rsqr = math.sqrt((x*x)+(y*y))
	res_x = ((x*math.sin(rsqr))-(y*math.cos(rsqr)))
	res_y = ((x*math.cos(rsqr))+(y*math.sin(rsqr)))
	return res_x, res_y
horseshoe =(x, y)->
	factor = (1/(math.sqrt((x*x)+(y*y))))
	return (factor*((x-y)*(x+y))), (factor*(2*(x*y)))
polar =(x, y) ->
	return (math.atan(x/y)*math.pi), (((x*x)+(y*y))-1)
handkerchief =(x, y)->
	r = math.sqrt((x*x)+(y*y))
	arcTan = math.atan(x/y)
	return (r*math.sin(arcTan+r)), (r*math.cos(arcTan-r))
heart =(x, y)->
	r = math.sqrt((x*x)+(y*y))
	arcTan = math.atan(x/y)
	return (r*math.sin(arcTan*r)), (r*(-math.cos(arcTan*r)))
disc =(x, y)->
	r = math.sqrt((x*x)+(y*y))
	arcTan = math.atan(x/y)
	arctanPi = (arcTan*math.pi)
	return (arctanPi*(math.sin(math.pi*r))), (arctanPi*(math.cos(math.pi*r)))
spiral =(x, y)->
	r = math.sqrt((x*x)+(y*y))
	factor = (1/(math.sqrt((x*x)+(y*y))))
	arcTan = math.atan(x/y)
	return (factor*(math.cos(arcTan)+math.sin(r))), (factor*(math.sin(arcTan-math.cos(r))))
hyperbolic =(x, y)->
	r = math.sqrt((x*x)+(y*y))
	arcTan = math.atan(x/y)
	return (math.sin(arcTan)/r), (r*math.cos(arcTan))
diamond =(x, y)->
	r = math.sqrt((x*x)+(y*y))
	arcTan = math.atan(x/y)
	return (math.sin(arcTan*math.cos(r))), (math.cos(arcTan*math.sin(r)))
ex =(x, y)->
	r = math.sqrt((x*x)+(y*y))
	arcTan = math.atan(x/y)
	p0 = math.sin(arcTan+r)
	p0 = math.pow(p0,3)
	p1 = math.cos(arcTan-r)
	p1 = math.pow(p1,3)
	return (r*(p0+p1)), (r*(p0-p1))
julia =(x, y)->
	r = math.sqrt((x*x)+(y*y))
	arcTan = math.atan(x/y)
	omega = if (math.random! >= 0.5) then math.pi else 0
	res_x = (r*(math.cos((arcTan*0.5)+omega)))
	res_y = (r*(math.sin((arcTan*0.5)+omega)))
	return res_x, res_y
bent =(x, y)->
	if (x < 0 and y >= 0) then return (x*2), (y)
	elseif (x >= 0 and y < 0) then return (x), (y*0.5)
	elseif (x < 0 and y < 0) then return (x*2), (y*0.5)
	return (x), (y)
waves =(x, y, a, b, c, d, e, f)->
	return (x+b*math.sin(y/(c*c))), (y+e*math.sin(x/(f*f)))
fisheye =(x, y)->
	r = math.sqrt((x*x)+(y*y))
	factor = ((r+1)*0.5)
	return (factor*y), (factor*x)
eyefish =(x, y)->
	r = math.sqrt((x*x) + (y*y))
	factor = ((r + 1)*0.5)
	return (factor*x), (factor*y)
popcorn =(x, y, a, b, c, d, e, f)->
	return (x+c*math.sin(math.tan(3*y))), (y+f*math.sin(math.tan(3*x)))
power =(x, y)->
	r = math.sqrt((x*x)+(y*y))
	arcTan = math.atan(x/y)
	factor = r^(math.sin(arcTan))
	return (factor*(math.cos(arcTan))), (math.sin(arcTan))
cosine =(x, y)->
	res_x = (math.cos(math.pi*x)*math.cosh(y))
	res_y = (-(math.sin(math.pi*x)*math.sinh(y)))
	return res_x, res_y
rings =(x, y, a, b, c, d, e, f)->
	r = math.sqrt((x*x)+(y*y))
	arcTan = math.atan(x/y)
	factor = (r+(c*c))%(2*(c*c)-(c*c)+r*(1-(c*c)))
	return (factor*math.cos(arcTan)), (factor*math.sin(arcTan))
fan =(x, y, a, b, c, d, e, f)->
	t = (math.pi*(c*c))
	r = math.sqrt((x*x)+(y*y))
	arcTan = math.atan(x/y)
	if ((arcTan+f)%t) > (t*0.5) then
		return (r*math.cos(arcTan-(t*0.5))), (r*math.sin(arcTan-(t*0.5)))
	return (r*math.cos(arcTan+(t*0.5))), (r*math.sin(arcTan+(t*0.5)))
blob =(x, y, b)->
	r = math.sqrt((x*x)+(y*y))
	arcTan = math.atan(x/y)
	factor = r*(b.Low+((b.High-b.Low)*0.5)*math.sin(b.Waves*arcTan)+1)
	return (factor*math.cos(arcTan)), (factor*math.sin(arcTan))
pdj =(x, y, a, b, c, d, e, f)->
	return (math.sin(a*y)-math.cos(b*x)), (math.sin(c*x)-math.cos(d*y))
bubble =(x, y)->
	r = math.sqrt((x*x)+(y*y))
	factor = (4/((r*r)+4))
	return (factor*x), (factor*y)
cylinder =(x, y)->
	return (math.sin(x)), (y)
perspective =(x, y, angle, dist)->
	factor = dist/(dist-(y*math.sin(angle)))
	return (factor*x), (factor*(y*math.cos(angle)))
noise =(x, y)->
	rand = math.random(0,1)
	rand2 = math.random(0,1)
	res_x = (rand*(x*math.cos(2*math.pi*rand2)))
	res_y = (rand*(y*math.sin(2*math.pi*rand2)))
	return res_x, res_y
-- pie =(x, y, slices, rotation, thickness)->
-- 	t1 = truncate(math.random!*slices)
-- 	t2 = rotation+((2*math.pi)/(slices))*(t1+math.random!*thickness)
-- 	r0 = math.random!
-- 	return (r0*math.cos(t2)), (r0*math.sin(t2))
-- ngon =(x, y, power, sides, corners, circle)->
-- 	p2 = (2*math.pi)/sides
-- 	iArcTan = math.atan(y/x)
-- 	t3 = (iArcTan-(p2*math.floor(iArcTan/p2)))
-- 	t4 = if (t3 > (p2*0.5)) then t3 else (t3-p2)
-- 	k = (corners*(1/(math.cos(t4))+circle))/(math.pow(r,power))-- r?
-- 	return (k*x), (k*y)
curl =(x, y, c1, c2)->
	t1 = (1+(c1*x)+c2*((x*x)-(y*y)))
	t2 = (c1*y)+(2*c2*x*y)
	factor = (1/((t1*t1)+(t2*t2)))
	return (factor*((x*t1)+(y*t2))), (factor*((y*t1)-(x*t2)))
rectangles =(x, y, rX, rY)->
	return (((2*math.floor(x/rX) + 1)*rX)-x), (((2*math.floor(y/rY)+1)*rY)-y)
tangent =(x, y)->
	return (math.sin(x)/math.cos(y)), (math.tan(y))
cross =(x, y)->
	factor = math.sqrt(1/(((x*x)-(y*y))*((x*x)-(y*y))))
	return (factor*x), (factor*y)

{
     :cross
}