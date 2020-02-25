# Mario Game Project
# Team 5 CS 3100

import pygame

# SceneBase
# Parent class for all future scenes
class SceneBase:
    def __init__(self):
        self.next = self

    # Receive all of the events that have happened since the last frame.
    def ProcessInput(self, events, pressed_keys):
        print("you didn't override this in the child class")

    # All of the game logic for this scene goes in here (e.g. movement)
    def Update(self):
        print("you didn't override this in the child class")

    # All of the logic for rendering the screen goes in here.
    def Render(self, screen):
        print("you didn't override this in the child class")
    
    # Takes in the next scene and goes to that scene.
    def SwitchToScene(self, next_scene):
        self.next = next_scene
    # Ends the game process
    def Terminate(self):
        self.SwitchToScene(None)

# What we will display at the title of the game
# todo: probably have it set up to press space to play default level,
# press enter to load level?
class TitleScene(SceneBase):
    def __init__(self):
        SceneBase.__init__(self)
    
    def ProcessInput(self, events, pressed_keys):
        for event in events:
            # 1 example: if we get a keydown and that keydown is up, terminate the game.
            if event.type == pygame.KEYDOWN and event.key == pygame.K_UP:
                self.Terminate()
    def Update(self):
        pass
    def Render(self, screen):
        # just fills it white for now
        screen.fill((0, 0, 0))
    
# The main scene for the actual mario game
class GameScene(SceneBase):
    def __init__(self):
        SceneBase.__init__(self)

        def ProcessInput(self, events, pressed_keys):
            pass
        def Update(self):
            pass
        def Render(self, screen):
            screen.fill((0,0,255))
def main():
    pygame.init()
    # default values for the width and height
    windowWidth = 400
    windowHeight = 600
    screen = pygame.display.set_mode((windowWidth, windowHeight))
    
    active_scene = TitleScene()

    while active_scene != None:
        pressed_keys = pygame.key.get_pressed()
        filtered_events = []
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                active_scene.Terminate()
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    active_scene.Terminate()
                
        active_scene.ProcessInput(filtered_events, pressed_keys)
        active_scene.Update()
        active_scene.Render(screen)
        active_scene = active_scene.next

        pygame.display.flip()

    return 
main()