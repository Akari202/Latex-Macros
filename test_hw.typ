#import "lib.typ": *
#{ is-homework = true }
#show: homework.with(
  homework-title: "Homework 5",
  course-number: "ME 324",
  course: "Dynamical Systems",
  instructor: "Professor Ajit Achuthan",
  class-time: "Section 1",
  due-date: "Tuesday October 29th, in class",
)

#problem[
  For the spring mass system in @B-5-2, the moment of inertia of the pulley about the axis of
  rotation is $J$ and the radius is $R$. Assume that the system is initially in equilibrium. The
  gravitational force of mass $m$ causes a static deflection of the spring such that
  $k delta = m g$. Assuming that the displacement $y$ of mass $m$ is measured from the equilibrium
  position, obtain a state-space representation of the system. The external force $u$ applied to the
  mass $m$ is the input and the displacement $y$ is the output of the system. #figure(
    image("Screen Shot 2024-10-22 at 16.11.02.png", width: 25%),
    caption: [Spring mass pulley system],
    alt: "A mechanical system diagram of a mass-pulley-spring assembly. The pulley of radius R is fixed, with a cable looped over it connecting a mass m to a vertical spring with stiffness k. The system's state is defined by y, the downward displacement of the mass, theta, the angular rotation of the pulley, and delta, the vertical stretch of the spring. External forces and components are labeled, including the gravitational force on the mass and a downward input u acting on the mass",
  ) <B-5-2>
  #hint[
    Note that the energy method (the way we learned) is not applicable here because there is an
    input force doing work on the system and therefore, the total energy is not a constant but equal
    to the work done by the input force. Instead of energy method, I would suggest force method:
    $J dot.double(theta) = sum T(t)$ about the centroidal axis of the pulley.
  ]
  #solution[
    By summing the moments $J dot.double(theta) = sum T(t)$ to obtain the equations of motion:
    $ J dot.double(theta) = R u - R m dot.double(y) - R^2 theta k $
    $ J dot.double(theta) = R u - R^2 m dot.double(theta) - R^2 theta k $
    $ J dot.double(theta) + R^2 m dot.double(theta) = R u - R^2 theta k $
    $ (J + R^2 m) dot.double(theta) = R u - R^2 theta k $
    $ dot.double(theta) = (R u - R^2 theta k) / (J + R^2 m) $
    To find the state space transformation we take $x_1 = theta$ and $x_2 = dot(theta)$. Therefore
    $dot(x)_1 = x_2$ and $dot(x)_2 = dot.double(theta)$ then
    $ dot(x)_2 = (R u - R^2 x_1 k) / (J + R^2 m) $
    $ dot(x)_2 = (R u) / (J + R^2 m) - (R^2 x_1 k) / (J + R^2 m) $
    From state-space definition:
    $ dot(x)_2 = a_2 / a_0 x_1 - a_1 / a_0 x_2 + 1 / a_0 u $
    #align(center)[#rect[
      $
        A = mat(
          delim: "[",
          0, 1;
          (R^2 k) / (J + R^2 m), 0;
        )
      $
      $
        B = mat(
          delim: "[",
          0, R / (J + R^2 m);
        )
      $
      $
        C = mat(
          delim: "[",
          1, 0;
        )
      $
      $
        D = mat(
          delim: "[",
          0;
        )
      $
    ]]
  ]
]
