import axios from "axios";

var g_mapperData = {
    400: {
        '0': {
            count: 508,
            coords: [
                [71.4, 96.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [81.5, 96.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.9, 96.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.1, 96.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.5, 96.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.3, 96, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.9, 95.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.6, 95.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [83, 94.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.5, 94.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.8, 93.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.6, 93.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.6, 93.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.9, 93.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.4, 93.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.2, 93, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.2, 92.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.4, 92.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.1, 92.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.3, 92.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.7, 91.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87.1, 91.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77, 91.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.4, 91.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.5, 91.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.8, 91, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68, 90.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.9, 90.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.4, 90.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.6, 90.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.8, 90.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.3, 90, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [81.4, 90, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.6, 89.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.1, 88.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87.9, 88.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.8, 88.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [83.3, 88.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [91.2, 87.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.3, 87.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [84.2, 87.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [84, 87.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85, 86.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.7, 85.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.9, 85.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [91.8, 85.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.2, 84.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [91.8, 84.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [91.5, 84.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [86.6, 84, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87, 83.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87.6, 82.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.5, 82, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [92.3, 81.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.5, 81.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [93.2, 81.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [93.3, 81.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.7, 81.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.9, 81, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [95.2, 80.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [95.3, 80.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [94.8, 80.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.8, 80.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [93.1, 80, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [92.7, 79.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [89, 79.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.4, 79.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [94.4, 79.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [93.9, 79.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.6, 79.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [94.3, 78.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [89.4, 78.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.5, 78, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [89.4, 77.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [96.1, 77.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [95.2, 77.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [95, 76.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [89.3, 76.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.4, 76.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.6, 75.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [95.2, 75.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.7, 75, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [94.7, 74.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.9, 74.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.8, 74, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.9, 73.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.3, 73, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.8, 72.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [94.7, 72.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87.5, 72.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87.7, 72, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.9, 71.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87.6, 71.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [89.3, 69.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70, 69.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.8, 68.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.7, 67.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [89.8, 67.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.3, 67.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [89, 66.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [90.2, 66.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [91.1, 66.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.1, 65.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [90.8, 64.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [86.4, 64.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.5, 63.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [90.8, 63.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.5, 63.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.5, 63.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.6, 62.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.2, 62.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.4, 62.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38, 62.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.1, 62.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.6, 62, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [86.4, 61.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87.3, 61.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.2, 61.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.6, 61.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87.1, 61.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.9, 61.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.1, 61.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87, 61, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.8, 61, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.5, 60.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.8, 60.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.3, 60.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.5, 60.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.4, 60.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.8, 60.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.1, 60, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88, 60, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.3, 60, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.8, 59.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42, 59.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.9, 59.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.9, 59.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.7, 59.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.9, 59.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.9, 59.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87.1, 59, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.4, 58.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.7, 58.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [86.4, 58.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.5, 58.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.4, 58.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.4, 58.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29, 58, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.7, 57.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.9, 57.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.3, 57.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.3, 57.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.1, 57.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.4, 57.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58, 57, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.8, 56.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25, 56.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [86.4, 56.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.6, 56.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.4, 56.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.6, 56.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66, 56.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.1, 56.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.3, 56.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.8, 56, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.2, 55.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41, 55.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.9, 55.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.9, 55.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.9, 55.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27, 55.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.3, 55.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40, 55.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.3, 55.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.1, 55.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.8, 54.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.1, 54.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.6, 54.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 54.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62, 54.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25, 54.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.2, 54.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.5, 54.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.9, 54.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45, 54, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.3, 53.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.2, 53.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.7, 53.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.2, 53.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.7, 53.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.5, 53.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [83.9, 53.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.3, 53.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.5, 53.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.4, 53.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.7, 53.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.9, 53.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.7, 53.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.5, 53.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.7, 53, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.6, 53, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.1, 53, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.3, 52.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.8, 52.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.6, 52.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.9, 52.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.7, 52.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.1, 52.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.5, 52.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 52, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.7, 52, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75, 51.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.9, 51.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.4, 51.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.2, 51.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.6, 51.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.7, 51.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.9, 51.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [81.1, 51.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.9, 51.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.6, 51.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.2, 51.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.4, 51.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.4, 51.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.4, 51.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [81.3, 51.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.2, 51, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.2, 51, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.7, 50.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.8, 50.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.4, 50.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.1, 50.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.9, 50.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.2, 50.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.8, 50.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.2, 50.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.5, 50.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.1, 50.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.4, 50.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.8, 50, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.9, 49.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.2, 49.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.3, 49.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.7, 49.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.5, 49.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.5, 49.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.8, 49.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.3, 49.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.8, 49.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.3, 49.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.7, 49.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.1, 48.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.9, 48.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29, 48.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.9, 48.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.5, 48.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.3, 48.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.8, 48, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.4, 47.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.5, 47.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18, 47.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.9, 47.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.3, 47.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.1, 47.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.5, 47.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.8, 47.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.6, 47.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.6, 47, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.1, 47, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.9, 47, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.1, 46.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.5, 46.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.5, 46.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.4, 46.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.7, 46.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.9, 46.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.9, 46.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.7, 46.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.6, 46.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.1, 46.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.2, 46.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.6, 46.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.5, 46.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.1, 46.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.8, 46.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.2, 46, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.3, 45.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.4, 45.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.9, 45.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.5, 45.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.5, 45.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.5, 45.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.9, 45.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.4, 44.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.1, 44.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.1, 44.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.8, 44.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.8, 44.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.5, 44.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.4, 44, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.9, 44, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.7, 43.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.1, 43.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.2, 43.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.1, 43.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.5, 43.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.5, 43.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.1, 43.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.9, 43.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.1, 42.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.5, 42.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.6, 41.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.5, 41.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.3, 41.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21, 41.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.3, 41.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42, 40.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.3, 40.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.8, 40.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.2, 40.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.4, 40.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48, 40, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20, 40, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.7, 40, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.2, 39.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.3, 39.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.5, 39.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.1, 39.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.3, 38.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.6, 38.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.7, 38.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.4, 38.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26, 38.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.9, 38.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.9, 38, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.4, 38, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25, 38, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.5, 37.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.3, 37.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.6, 37.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.7, 37.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.6, 37, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.9, 37, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.4, 37, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.8, 36.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26, 36.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.4, 36.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43, 36.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17, 36.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.1, 36.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.9, 35.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.7, 35.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.1, 35.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.6, 35.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.6, 35.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.8, 35.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.8, 35.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 35, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.1, 34.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.5, 34.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.6, 34.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28, 34.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.8, 34.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40, 34.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.9, 34.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.2, 34.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.4, 34, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.9, 34, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39, 34, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.3, 33.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.1, 33.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.4, 33.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.1, 33.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.3, 33.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.1, 33.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.5, 33.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.3, 32.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28, 32.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.9, 32.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.1, 32.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25, 32.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.3, 32.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23, 32, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.1, 31.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.2, 31.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.5, 31.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.5, 30.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.2, 30.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.8, 30.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.7, 30.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.3, 30.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.8, 30.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.9, 30, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.4, 29.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.1, 29.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.4, 29.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.7, 29.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26, 29.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35, 29.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.9, 28.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.7, 28.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.6, 28.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17, 28.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.1, 28, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18, 27.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.8, 27.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13, 27.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.8, 27.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.9, 27.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27, 27.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.9, 27.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.6, 27.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.4, 27.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.3, 26.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.5, 26.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.4, 26.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.4, 26.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.1, 26.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12.3, 26.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12.6, 26.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.4, 26.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.3, 26, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.2, 25.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.6, 25.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.3, 25.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.5, 25.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.2, 25.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.3, 25.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.5, 25.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34, 25.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.1, 25.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.6, 25.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.5, 25.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.3, 25.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12, 24.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.5, 24.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.1, 24.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.1, 24.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.3, 24.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.9, 24.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.4, 24.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.1, 24.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25, 24.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.1, 23.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.2, 23.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.4, 23.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10.8, 23.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.2, 23.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.3, 23.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.4, 23.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.3, 23.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.5, 22.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.5, 22.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.5, 22.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.7, 22.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.4, 22.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.3, 22.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28, 22.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.4, 22.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.9, 22.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10, 22.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.1, 22.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.4, 22.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.4, 21.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [9.1, 21.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [8.9, 21.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.8, 21.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.3, 21.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10, 21.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.6, 21, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12.3, 20.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [9.5, 20.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.8, 20.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [9.5, 20.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13, 20, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.6, 20, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.9, 19.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.7, 19.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.5, 18.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.7, 18.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.7, 18.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12.1, 18.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [9.8, 18, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.6, 17.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10.7, 17.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.2, 17.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10.9, 17.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12.9, 16.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.4, 15.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.3, 15.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13.6, 13.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10.9, 13.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.1, 13.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10, 13.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [9.9, 13.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.5, 12.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12, 12.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13.5, 12.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.9, 12.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12.6, 11.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [9.1, 11.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13, 11.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12.9, 10.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [9.5, 10.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [9.7, 9.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [9.5, 9.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10.2, 7.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10.5, 7.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    331: {
        '0': {
            count: 278,
            coords: [
                [70.4, 86, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.9, 85.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.5, 84.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.2, 81.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.5, 80.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.9, 80.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.5, 79.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.5, 79.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87.5, 79.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.5, 79.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67, 79.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.4, 79.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [83.3, 79.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [86.6, 79.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.3, 78.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.7, 78.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.2, 78.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.6, 78.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.8, 78.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.6, 77.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [90.2, 77.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.8, 77.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.4, 77.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.9, 76.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [84.5, 76.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [89.9, 76.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.6, 76.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.5, 75.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.3, 75.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.8, 75.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.5, 75.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [84.9, 74.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.5, 74.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.1, 74.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.1, 74, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.3, 73.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.7, 73.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.8, 73.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [81.1, 73.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [84.6, 73.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.8, 72.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.8, 72.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.9, 72.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.4, 72, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.7, 71.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [83.2, 71.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40, 71.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.4, 71.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.1, 71.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.8, 70.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.9, 70.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.4, 70.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.2, 70.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33, 70.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.7, 69.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.3, 69.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.8, 69.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.7, 69.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.6, 69.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.1, 69.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.5, 68.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.6, 68.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.1, 68.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.5, 68.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.3, 68.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.1, 67.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 67.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.7, 66.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.3, 66.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.7, 66.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.9, 65.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.8, 65.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.1, 65, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62, 65, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.4, 64.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.4, 64.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.4, 64.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.8, 64.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39, 64.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.7, 64.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.8, 64.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.1, 64.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.9, 64.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.1, 63.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.4, 63.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.4, 63.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.1, 63.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.7, 63.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.5, 63, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.8, 62.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.9, 62.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.3, 62.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.8, 62.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.4, 61.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.2, 61.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.5, 60.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.5, 60.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.7, 60.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.5, 60.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.8, 59.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25, 59.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.6, 59.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.6, 59.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.4, 59, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.3, 58.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.8, 58.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.4, 57.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.6, 57.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.1, 57.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.8, 56.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.9, 56.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.9, 55.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.2, 55.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.2, 55.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.7, 54.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.8, 54.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.7, 54.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.3, 54.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66, 54.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.8, 54.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.4, 54.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.1, 54.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18, 53.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.6, 53.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.8, 53.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.2, 53.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.3, 53.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.4, 53, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.4, 52.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.1, 52, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.8, 52, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.8, 51.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.5, 51.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.7, 50.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.8, 50.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.1, 50.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82, 50.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54, 50.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.4, 50.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.5, 50.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.4, 49.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.3, 48.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82, 48.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.5, 48.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.7, 48.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.5, 48.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [81.6, 47.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.2, 47.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.1, 47.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.5, 47.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.5, 47.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.6, 47.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67, 47.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.5, 46.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.5, 46.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.7, 46.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.5, 46, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.1, 45.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.4, 45.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.8, 44.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.1, 44.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.8, 44.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.1, 44.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.9, 44.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.6, 43.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.8, 43.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.2, 43.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.3, 43.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.1, 43.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.9, 43.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.9, 43.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.1, 42.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.1, 42.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.9, 42.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.7, 42.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.9, 42.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21, 42.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.3, 42, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.6, 41.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.4, 41.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44, 41.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.5, 41.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.7, 41.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.4, 41, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.1, 40.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.7, 40.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.6, 40.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.7, 40.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.9, 39.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.9, 38.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.6, 38.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.4, 38.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.9, 38.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.2, 38, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.6, 37.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.4, 37.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.9, 37.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.6, 37.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.9, 37.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.9, 37, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.3, 36.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.7, 36.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.4, 36.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.5, 36.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.1, 36.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.3, 35.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.6, 35.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.6, 35.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.1, 35.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.3, 35.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.5, 35.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.8, 35.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.2, 34.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.8, 34.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43, 34.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43, 34.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29, 34.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.7, 33.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43, 33.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.3, 33.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.5, 33.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20, 33.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.3, 33.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.2, 33, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.8, 32.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.3, 32.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30, 32.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.7, 32.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.1, 32.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 32.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.8, 32.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.3, 32.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.5, 32.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.6, 32, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55, 32, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.2, 32, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.4, 31.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.6, 31.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.8, 31, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.6, 30.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.7, 30.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.8, 30.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.2, 30.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.9, 30, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.1, 29.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.9, 29.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.2, 28.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.2, 28.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.7, 28.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.7, 28.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.1, 28, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.5, 27.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.5, 27.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.8, 27.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.5, 27.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.9, 26.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.7, 26.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17, 23.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.5, 23.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.9, 22.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.6, 22.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.8, 21.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.7, 20.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.6, 19.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.1, 19.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.7, 19.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.4, 19.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.8, 19.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.6, 18.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26, 17.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.7, 17.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.7, 15.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.8, 15, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15, 14, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.8, 13.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12.9, 13.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.2, 13.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.1, 13, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    148: {
        '0': {
            count: 271,
            coords: [
                [37.8, 93.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.2, 93.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38, 92.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.2, 91.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.7, 91.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47, 91.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.4, 90.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48, 89.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.9, 89.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.1, 89.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.9, 89.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.3, 88.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.2, 88.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.6, 88.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.5, 87, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33, 86.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.4, 86.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40, 86.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.3, 86.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46, 86.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32, 85.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.9, 85.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.2, 85.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.1, 85.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.9, 85.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.1, 85.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.1, 85, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.7, 84.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.3, 84.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.2, 84.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.1, 84.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.3, 84.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.6, 84.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.8, 83.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.8, 83.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.3, 83.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.8, 83.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.1, 83.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.4, 83.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.6, 83.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.2, 83.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.6, 83.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.6, 83.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.9, 83.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.4, 83, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.6, 83, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.7, 82.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.7, 82.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.9, 82.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.2, 82.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.3, 82.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.7, 81.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.9, 81.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.1, 79.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.5, 79.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.5, 74.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46, 73.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.8, 73, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.9, 72.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.1, 72.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.7, 72.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.5, 71.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.9, 71.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.9, 71.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.2, 71.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42, 71.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44, 70.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.7, 69.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.3, 69.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.8, 68.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45, 68.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.1, 68.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.6, 68, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.7, 67.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.4, 67.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.5, 66.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.4, 66.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.4, 65.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.6, 65.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.4, 63.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40, 63.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.6, 63.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.2, 62.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40, 62, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.5, 59.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.9, 59.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.4, 59.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.2, 59.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.2, 59, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40, 58.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.4, 58.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.1, 58.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.8, 57.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.6, 57.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.9, 57.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.1, 57.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.8, 55.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.1, 55.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.3, 55.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.9, 55.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.2, 55.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.6, 55, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.3, 54.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.6, 54.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45, 52.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.8, 52.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.4, 51.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.3, 50.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.2, 50.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.8, 48.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.6, 48.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.6, 47.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.6, 46.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.1, 46.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.1, 45.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.7, 45.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.9, 44.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.7, 44.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.5, 44.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.9, 42.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.7, 42.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.8, 41.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.7, 41.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.5, 41.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.3, 41.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45, 41.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47, 41.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39, 41.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.7, 41.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.5, 41, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.5, 41, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.1, 40.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.6, 40.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.5, 40.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47, 40.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.5, 39.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.4, 39.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.3, 39.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 38.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.2, 38.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.9, 38.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.9, 38.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.2, 38.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.3, 38.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.9, 38, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.2, 37.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.2, 37.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.9, 37.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.7, 37.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.6, 37.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.9, 37.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.3, 37, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46, 36.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.6, 36.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.3, 36.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.5, 36.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46, 36, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.2, 35.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.4, 35.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.3, 35.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.7, 35.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.6, 35, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.4, 34.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.5, 34.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.5, 34.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.5, 34.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.6, 33.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.6, 33.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.5, 33.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.2, 33.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.3, 33.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 33.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.6, 33.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.1, 32.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.1, 32.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.2, 32.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57, 32.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38, 32.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.3, 32, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.9, 32, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.1, 32, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.7, 31.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.5, 31.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.9, 31.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.4, 31.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.1, 31.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.5, 31.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.2, 31.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.1, 31.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.6, 31.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.4, 31.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.8, 30.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.9, 30.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.5, 30.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.2, 30.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.3, 30.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.3, 30.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.4, 30.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.5, 30.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43, 30, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.1, 29.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57, 29.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.2, 29.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.9, 29.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.4, 28.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.6, 28.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.3, 28.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.2, 28, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.5, 27.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.6, 27.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.5, 27.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.7, 27.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.6, 27, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.8, 26.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.3, 26.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.4, 26.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.2, 26.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.4, 25.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.6, 25.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60, 25.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.7, 25.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.8, 25, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.6, 23.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.5, 23.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.9, 22.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.6, 20.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.3, 20.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62, 20.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.5, 20.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.8, 20, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.7, 19.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54, 19.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.7, 19.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55, 19.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.6, 19.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.2, 19.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.9, 18.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.9, 18.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.8, 18.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.5, 18.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.3, 18.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.5, 18, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.8, 17.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.8, 17.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.3, 17.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.1, 16.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.5, 16.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.2, 16.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.3, 16, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61, 14.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.7, 14.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.1, 14.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.6, 14.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.7, 11.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.1, 11.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.7, 10.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59, 10.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64, 10.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.1, 10.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.7, 10, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59, 9.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.4, 9.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.1, 8.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.8, 8.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.5, 7.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.4, 6.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.6, 5.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.4, 5.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65, 4.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.7, 4.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65, 4.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    406: {
        '0': {
            count: 221,
            coords: [
                [77.4, 92.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75, 91.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.2, 91.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.5, 91.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74, 90.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.4, 89.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.2, 89.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.4, 89.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.5, 89.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.9, 89.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.9, 88.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.2, 88.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.4, 88.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.6, 87.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.5, 87.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.3, 87.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.9, 87.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60, 86.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.8, 86.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68, 86.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.5, 86.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.5, 85.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.4, 85.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.6, 85.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.2, 85.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.1, 84.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.7, 84.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.9, 83.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.1, 83.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.7, 83.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.4, 83.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.6, 82.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.8, 82.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.8, 82.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78, 82.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.7, 82.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.3, 81.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [81.5, 81.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.3, 81.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65, 81.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.6, 79.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.4, 79.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.7, 78.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.8, 78.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.7, 78.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.5, 78.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.5, 78, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.9, 77.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80, 77.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.5, 77.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.3, 77.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.2, 76.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.4, 76.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.4, 76, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.3, 76, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.9, 75.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.5, 75.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.1, 75.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.4, 75, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.1, 74.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.6, 74.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.6, 74.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.5, 74.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41, 74.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77, 74.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.1, 74, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.1, 73.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.7, 73.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.5, 73.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.1, 73.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.1, 73.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47, 72.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.1, 72.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.5, 72.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.1, 72, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.8, 71.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.8, 71.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51, 70.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.9, 70.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.9, 69.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.7, 69.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.2, 69.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.9, 68.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.9, 68.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.3, 67.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 66.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.6, 66.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.4, 66.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.7, 66.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.2, 66, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.1, 65.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.9, 65.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.6, 65, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.9, 65, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.6, 64.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.8, 64.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.8, 64.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.9, 63.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.7, 63.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.9, 63.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42, 63.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.6, 62.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.8, 62.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.2, 61.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.6, 61.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53, 61.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.4, 61.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.3, 61.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.2, 61.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.4, 61.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.9, 60.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.1, 60.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.2, 59.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.8, 59.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.7, 59.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.8, 59.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.6, 59.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.1, 58.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.6, 57.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.7, 57.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.1, 57.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.1, 57, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.5, 56.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.9, 56.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.4, 56.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.6, 55.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.9, 55.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.9, 55.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.9, 55.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.3, 55.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.7, 55.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.6, 55.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.9, 55.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35, 54.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.4, 54, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.5, 53.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.3, 52.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.1, 52.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.9, 52.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.1, 52.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.2, 51.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.7, 51.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.9, 51.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55, 51.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.8, 50.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.2, 50.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.9, 50.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.4, 49.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.8, 48.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.4, 48.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.6, 48.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.2, 48.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.7, 48.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.3, 48.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.4, 48, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.6, 47.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.8, 47.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.6, 47.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.8, 46.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.8, 46.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.8, 46.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.8, 45.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.4, 45.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.1, 45.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.2, 44.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.5, 44.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.8, 43.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44, 43.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.6, 43.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.5, 43.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57, 43.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.3, 43, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.9, 42.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.8, 42.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.1, 42.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.6, 41.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52, 41.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.6, 41.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.4, 41, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.5, 40.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.4, 40.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.5, 40.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.5, 39.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.5, 39.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.2, 39.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.7, 39.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.3, 39.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.4, 38.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52, 38.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.9, 38, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.9, 37.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44, 37.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.9, 36, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.1, 35.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.7, 35.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.2, 34.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.8, 34.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49, 33.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.4, 32.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.1, 31.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.2, 30.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.3, 30.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.7, 30.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.1, 30.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.5, 29.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.4, 29.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.7, 28.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44, 27.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.6, 27.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.3, 26.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.1, 26.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.4, 25, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.8, 23.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.8, 20.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.2, 19.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.8, 19.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.8, 19, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.2, 18.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.1, 17.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 17.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.4, 16.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    16: {
        '0': {
            count: 198,
            coords: [
                [49.1, 84.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.2, 83.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.8, 83.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48, 82.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.3, 82.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36, 82.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.8, 81.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.7, 81.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.2, 81, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.5, 80.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.8, 80.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.6, 80.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.2, 80.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.3, 80.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33, 80.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.2, 80, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.8, 79.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.4, 79.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.9, 78.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53, 78.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.8, 78, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.7, 77.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.2, 77.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.8, 77.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.9, 77, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10.1, 76.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.2, 76.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.8, 76.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.3, 75.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.4, 75.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12.9, 74.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.6, 74.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.4, 74.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12, 73.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.9, 73.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.5, 73.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.3, 72.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.5, 72.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.4, 72.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.5, 72.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.4, 72, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.4, 71.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.9, 71.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.3, 71.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.9, 71.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.9, 71, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.3, 71, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.8, 70.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.5, 70.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19, 70.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.6, 70.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.9, 70.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [9.8, 70.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.3, 69.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.1, 69, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10.1, 68.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.2, 68.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.8, 68.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.1, 67.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.5, 67.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.8, 67.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.7, 67.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.2, 67.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.8, 67.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12.9, 67, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10.9, 67, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13.2, 66.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.6, 66.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39, 66, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.9, 65.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.3, 65.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.5, 65.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.2, 64.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.3, 64.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.1, 64.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.6, 64.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.3, 63.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13, 63.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.4, 62.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.1, 62.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.6, 61.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.4, 61.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.9, 61, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16, 58.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.9, 58.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.2, 58.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.8, 57, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.7, 56.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.9, 56.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.2, 55.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26, 55.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.8, 54.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.2, 53.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.9, 53.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.7, 53.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.5, 52.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37, 52.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.4, 52.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12.3, 50.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.5, 50.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.1, 49, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.3, 48.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.3, 48, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.3, 47.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13, 47.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.8, 46.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.9, 46.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.2, 46, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.8, 45.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21, 45.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26, 45.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.9, 44.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.7, 44.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.6, 43.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.9, 43.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.2, 42.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.8, 41.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.4, 41.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.2, 41.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.1, 40, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.5, 39.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.4, 39.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41, 39.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.5, 39.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.1, 39.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.6, 38.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.6, 38.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.4, 37.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.5, 37.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.1, 37.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.2, 36.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.3, 36.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.1, 35.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72, 35.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.5, 34.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.8, 34.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.1, 34.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.5, 34.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.3, 33.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.2, 33.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.7, 33.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32, 33.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.9, 33, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.7, 32.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.6, 32.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.2, 31.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.9, 31.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.1, 31.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.3, 31.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.7, 31.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.8, 31.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42, 30.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.9, 30.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.9, 30.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.9, 30.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.6, 30.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.1, 30.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.3, 30.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72, 29.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.7, 29.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.4, 29.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.3, 29.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68, 29, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.4, 28.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.8, 28, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51, 26.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.9, 26.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.8, 26.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.3, 26.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.1, 26.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.1, 26.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.2, 25.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.7, 24, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.2, 23.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48, 23, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.8, 22.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.3, 22.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.6, 22.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.9, 21.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.5, 20.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.8, 20.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.2, 20.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.6, 20.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.9, 19.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.5, 19.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.6, 18.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.1, 17.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.8, 17.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.8, 17.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51, 16.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.7, 16, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67, 15.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.9, 14.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.1, 14.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.1, 14, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71, 13.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.9, 12.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.7, 11, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    14: {
        '0': {
            count: 190,
            coords: [
                [51.3, 83.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.1, 83.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.7, 82.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.7, 81.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.5, 81.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.2, 81.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.4, 80, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54, 79.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.6, 79.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.8, 79.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.2, 79, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.1, 78.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.2, 78.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.5, 78.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.3, 78.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.4, 78.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.4, 77.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.7, 77.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.7, 76.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.6, 75.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.9, 71.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.4, 71, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.7, 70.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.2, 70, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.7, 69.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.8, 69.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.6, 67.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.2, 66.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.5, 66.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.5, 66, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.2, 65.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.7, 64.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.6, 63.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.1, 61.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.5, 61.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.1, 61.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59, 60.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.6, 60.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55, 60.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.5, 60.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.1, 60, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.7, 59.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.8, 58.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.2, 57.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.5, 56.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.6, 56.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.5, 55.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.6, 55.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.4, 55.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.7, 54.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.2, 54.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.5, 54.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61, 53.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.6, 53.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.4, 52.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.1, 52.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.2, 51.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.2, 51.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.9, 51.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.5, 50.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43, 50.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.1, 50.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.5, 50.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56, 49.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.5, 49.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.1, 49.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.2, 49.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.5, 49.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 48.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.3, 47.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.8, 47.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.2, 47.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.3, 47.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.7, 47.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.4, 46.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.8, 46.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.3, 46.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.5, 46.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.3, 46.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.3, 45.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.9, 45.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.3, 44.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.7, 44.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.1, 44.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.6, 42.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.5, 41.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.4, 41.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59, 40.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.4, 40.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.4, 40.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.7, 40.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.4, 39.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.1, 39.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.8, 39.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.4, 38.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.4, 38.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.2, 37, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48, 36.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.5, 35.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.1, 35.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.6, 34.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35, 33.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.3, 33.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.6, 33.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.9, 33.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.7, 33.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.3, 33, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.8, 33, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.6, 32.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.2, 31.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48, 31.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48, 31.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.5, 30.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.1, 30.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.7, 30.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.5, 29.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.2, 29.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.3, 29.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.9, 29.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.2, 29.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53, 29, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.9, 28.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.8, 28.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.4, 28.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45, 28, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.1, 27.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.8, 27.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.8, 27.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.2, 27.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.7, 27.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.1, 26.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.1, 26.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.1, 26.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.3, 25.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.2, 25.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.8, 25, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.5, 25, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.5, 24.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.5, 24.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.2, 24.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.7, 24.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.5, 23.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.6, 23.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.1, 23.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.5, 23.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.2, 23.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.3, 23.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.9, 22.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.8, 22.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49, 22.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.2, 22.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.5, 22.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.6, 22.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.3, 20.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.1, 20.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.9, 19.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.5, 19.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.5, 19.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.6, 19.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.3, 18.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.6, 17.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.5, 17.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.2, 17.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.1, 17.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.7, 17.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.3, 16.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.3, 16.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.1, 16.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.2, 16, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.6, 16, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.7, 15.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.8, 15.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.7, 15.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.5, 14.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.4, 14, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.3, 11, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.3, 10.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.6, 10.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.4, 10.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.7, 9.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.4, 9.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.8, 9.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.1, 9.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52, 9.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.7, 9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.2, 8.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.6, 8.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.6, 8.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.4, 8.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53, 7.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    17: {
        '0': {
            count: 184,
            coords: [
                [57.1, 91.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.9, 91.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.2, 90.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.5, 85.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.1, 84.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.3, 84.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.1, 83.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.7, 83.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.6, 82.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.8, 82.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.2, 82.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.3, 81.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.8, 81.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.7, 80.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48, 80.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.7, 80.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.5, 80, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.2, 79.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.1, 78.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.2, 78.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.8, 78.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.5, 78.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.7, 77.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.7, 77.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.2, 76.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.6, 76.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.3, 75, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.2, 74.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.4, 74.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.5, 73.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.7, 73.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.9, 73.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.7, 69.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.7, 68.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.4, 68, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.2, 67.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.7, 67.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.2, 66.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.7, 65.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.2, 64, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.6, 63.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.5, 62.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.3, 62.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.4, 62.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.1, 62.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.5, 62.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.7, 61.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.3, 61.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.6, 61.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.1, 60.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.8, 60.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.6, 60, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.7, 59.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.6, 59.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.8, 59.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40, 59.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.2, 59.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.3, 58.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68, 57.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.4, 56.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.5, 56.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65, 55.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.1, 54.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.8, 54.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.7, 54, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.2, 54, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.8, 53.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.9, 53.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.3, 52.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.2, 52.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.1, 52, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.2, 51.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.7, 50, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.5, 50, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.7, 49.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.9, 49.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.3, 49.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.4, 49.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49, 49.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.9, 49.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.1, 49.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.4, 49.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.7, 48.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.3, 48.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.3, 48.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.7, 47.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.2, 46.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.8, 45.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.3, 45.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.1, 45.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.7, 45.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.3, 45.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.7, 44.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.5, 44.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.6, 44.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.1, 44.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.5, 43.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.8, 43.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.5, 42.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.4, 42.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.6, 42.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29, 42.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.8, 41.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.4, 41.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54, 40.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.9, 40.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.9, 40.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.4, 39.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.2, 39.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.4, 39.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.7, 39.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.2, 39, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42, 38.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.4, 38.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.8, 38.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38, 37.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.6, 37.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.1, 37.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.4, 37.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.8, 36.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.9, 35.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.2, 35.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.8, 35.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.3, 35.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.1, 35, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.5, 35, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.1, 34.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.1, 34.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.1, 34.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.7, 34.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.4, 34.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 33.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.8, 33.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.4, 33.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.4, 33.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.6, 32.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.2, 31.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.1, 31.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.8, 30.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.3, 30.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.8, 30.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.3, 30.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.2, 30, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.9, 30, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.9, 29.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.4, 29.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.2, 29.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.3, 29.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.1, 29.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.7, 29.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.8, 29.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.8, 29.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.3, 29.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.6, 29, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.7, 28.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.9, 27.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.9, 27.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.3, 27.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.6, 27, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.2, 27, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.5, 26.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.2, 26.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.1, 26.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.6, 25.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.5, 24.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.6, 24.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.2, 24.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.3, 24.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.7, 23.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.4, 23.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.4, 23, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64, 22.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.4, 21.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.7, 21.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.7, 21.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.6, 19.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.6, 18, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.3, 17.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.9, 13.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.5, 12.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57, 12, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.3, 10.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66, 10.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67, 10.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    3: {
        '0': {
            count: 154,
            coords: [
                [12.5, 71.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12.1, 69.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.5, 68.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.3, 68.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12.5, 66.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.8, 66.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.1, 66, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.9, 65.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.3, 65.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.4, 65, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.6, 64.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26, 64.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.2, 64.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.8, 64.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.7, 64.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.3, 64, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12.3, 64, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39, 63.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.8, 63.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.4, 63.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.5, 63.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.9, 62.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.2, 62.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35, 62.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.7, 62.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.8, 62.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.7, 62, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.6, 61.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.3, 61.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.2, 61, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.8, 60.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.1, 60.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.1, 60.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13.5, 59.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.4, 59, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.8, 58.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63, 58.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66, 57.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.4, 57.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.3, 57.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.1, 57, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13, 56.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.8, 55.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22, 55.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.6, 55.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.1, 54.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.5, 54, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13.6, 54, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.2, 53.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.9, 53.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.2, 53.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.2, 53.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.9, 52.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.9, 52.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.3, 52.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.9, 52.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10.1, 52.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.7, 52, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.2, 51.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.9, 51.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.9, 50.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.8, 50.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.3, 50.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.7, 50.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.9, 50.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.7, 49.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13.4, 49.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.5, 49.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.9, 48.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.4, 48.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.3, 47.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.4, 47.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.8, 47, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.6, 46.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.3, 46.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.5, 46.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.8, 45.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.1, 44.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.8, 43.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.8, 43.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51, 43.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.6, 43.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.3, 42.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.1, 42.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.2, 41, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.4, 39.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23, 39.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.2, 38.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.3, 38.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.7, 38.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.4, 38.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.3, 38.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10.5, 38.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.6, 38, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20, 37.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.5, 37.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.2, 37.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.1, 36.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.4, 36.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.5, 36.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.3, 36.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10.9, 36.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.3, 35.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [12.1, 35.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.6, 35.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.3, 35.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.2, 35.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.8, 34.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.3, 34.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.5, 33.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.5, 33.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.8, 33.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72, 32.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.8, 32, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.2, 31.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.6, 30.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.7, 30.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.9, 29.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.3, 28.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.5, 28.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.8, 28.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.1, 28, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.2, 27.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55, 27.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.1, 27.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.8, 26, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.7, 25.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.6, 25, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.6, 24.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.3, 24.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.9, 23.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.8, 22.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.5, 22.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.3, 22, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54, 21.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.9, 21.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.6, 20.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.4, 19.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.3, 17.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47, 16.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.6, 15, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.1, 14.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.8, 13.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.6, 13, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.4, 12.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.4, 12.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.4, 12.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.3, 12.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.7, 12.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.8, 12.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.4, 11.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34, 11.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.8, 10.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.5, 8.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    44: {
        '0': {
            count: 148,
            coords: [
                [64, 76.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.8, 75.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30, 75, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.6, 74.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.7, 74.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.6, 73.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.5, 71.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.6, 71.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.6, 71, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.6, 70.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58, 70.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.4, 69.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.1, 69.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [10.8, 69, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.6, 68.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.6, 67.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.9, 67.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21, 66.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.2, 66.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.6, 66, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.5, 65.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.7, 65.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.1, 65, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.9, 63.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63, 63.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.7, 63.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.5, 63.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.9, 62.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.6, 62.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.4, 62, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13.9, 61.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.8, 60.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56, 59.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.5, 59.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.3, 59, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.1, 57, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.6, 56.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.1, 56.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.2, 56.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.4, 55.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.5, 54.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.8, 53.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.8, 53.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.8, 52.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.6, 52.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.4, 51.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.5, 51, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.7, 49.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.9, 49.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59, 49.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.5, 48.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.7, 48, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.3, 46.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.5, 46.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.6, 46.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.3, 45, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.2, 43.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.1, 43.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63, 43.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.2, 42.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.3, 42.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.3, 41.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.7, 40.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.5, 38.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.8, 38.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.9, 38, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74, 37.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.3, 36.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.5, 36.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.9, 35.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.5, 35.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.8, 35.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.4, 34.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28, 34.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73, 34, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69, 33.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.6, 33.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.1, 33.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.1, 33.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.9, 31.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.9, 31.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.8, 30.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.9, 29.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.9, 28.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.2, 28.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.9, 27.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32, 26.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.1, 25.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.3, 24.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.8, 24.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.5, 24.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.2, 24.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.2, 24.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.1, 23.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.7, 22.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.6, 22.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.4, 22.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.4, 22.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.4, 21.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.6, 21.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.2, 20.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.7, 20.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.1, 20.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.4, 20.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.4, 20.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.2, 19.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.7, 19.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.5, 19.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.8, 18.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.4, 18.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.9, 18.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.3, 18.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.5, 18, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.5, 17.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.1, 17.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.7, 17.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.8, 17.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.3, 17, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26, 16.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.6, 16.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.4, 15.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.4, 15.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.3, 15.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.9, 15.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.4, 15.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.5, 15, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.3, 15, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.8, 15, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.8, 14.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30, 14.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.6, 14, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.9, 13.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.4, 13.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.1, 13.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.8, 13, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.1, 12.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.2, 12.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.1, 12, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30, 12, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.2, 11.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.5, 11.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.6, 10.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.4, 10.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.7, 9.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.6, 9.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.6, 9.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.1, 8.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.2, 8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    11: {
        '0': {
            count: 143,
            coords: [
                [61.6, 80, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.4, 79.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.9, 78.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64, 78.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.5, 78.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.6, 76.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.2, 76.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.7, 76.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.4, 75.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.4, 75.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.1, 75.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.7, 74.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.2, 74.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.7, 74.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60, 74.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.9, 73, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64, 72.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.5, 71.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.1, 70.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.8, 69.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.8, 67.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.5, 67.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.7, 67.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46, 65.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.8, 64.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.5, 64.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.3, 63.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.7, 62.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.2, 62.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.4, 62.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.7, 62.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.9, 62.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.6, 62.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.5, 62.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.7, 61.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.5, 61.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47, 61.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.6, 61.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.1, 61, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.9, 60.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.1, 60.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.7, 60.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.7, 60, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.4, 60, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.7, 59.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.8, 59.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.4, 59, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.3, 58.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.9, 58.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56, 58.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.4, 58, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.9, 57.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.7, 56.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.2, 56.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.9, 55.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.5, 54.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.5, 52.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.1, 52.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.5, 51.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.2, 51.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.8, 51.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.4, 51.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.4, 50.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.7, 50.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.9, 50.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.8, 49.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.4, 48.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.1, 48.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.9, 48.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.3, 48.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.4, 48, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.8, 46.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.6, 46.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 46.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.3, 46.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38, 45.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36, 45.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.2, 45.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.6, 45.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.8, 45.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.7, 44.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.7, 43.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.7, 43.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.8, 43.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.9, 43.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.4, 43.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.8, 43.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.6, 43.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.4, 42.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.1, 42.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.4, 40.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.8, 40.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.5, 40.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.8, 39.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23, 38.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.2, 38.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.8, 37.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.6, 37.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.6, 35.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.4, 35.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31, 35, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.3, 34.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.9, 33.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.5, 33.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.3, 33.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.2, 33.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.4, 33, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68, 32.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.2, 32.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.4, 31.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.2, 31.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.2, 31.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.5, 31.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.4, 31.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.9, 30.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.3, 30.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.4, 30.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.9, 29.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.2, 29.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.9, 28.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.1, 28.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.2, 28.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.3, 28.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.4, 28, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.8, 27.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.1, 27.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.2, 26.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63, 25.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.6, 24.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.5, 24.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.7, 23.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.5, 22.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.1, 22.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.9, 22.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.9, 22.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.7, 22.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.9, 22.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.9, 22.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.2, 20.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.4, 18.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.2, 17, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.2, 16.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.2, 15.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    10: {
        '0': {
            count: 140,
            coords: [
                [37.6, 84.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.4, 84.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.6, 84.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.1, 84.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.8, 83.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.5, 83.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.3, 83.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.7, 82.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.7, 82.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.6, 82, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.1, 81.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.7, 81.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.9, 81.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.9, 81.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.4, 80.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.2, 80.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.7, 80.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.1, 80.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25, 80.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.9, 80.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.1, 80.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.2, 80.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.2, 79.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.3, 79.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.4, 79.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.5, 79.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.2, 79.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.7, 79.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.9, 79.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.3, 79.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.6, 78.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.7, 78.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.4, 78.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.1, 78.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.5, 78.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.6, 78.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.3, 77.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.6, 77.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71, 77.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.6, 77.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36, 77.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.2, 77.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.3, 77.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.5, 77, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.7, 76.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.1, 76.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.5, 76.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.4, 76.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.4, 76.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32, 76.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.3, 76.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.1, 76.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.8, 76.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.2, 75.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.4, 75.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.9, 74.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69, 74, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.1, 74, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.6, 73.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.8, 73.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.9, 72.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.6, 72.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.4, 72.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71, 72.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.3, 71.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51, 71.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.7, 70.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.5, 70.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.1, 69.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.8, 69.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.5, 68, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.3, 67.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.3, 63.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.8, 63.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.6, 63.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [81.8, 62.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.2, 62.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.6, 61.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.5, 60.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.1, 60.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.5, 60.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [83.9, 58.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.1, 58.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [84.1, 58.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.4, 57.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.5, 56.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60, 56.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.6, 56.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.9, 55.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [84.4, 55.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.7, 54.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.7, 54.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.6, 54, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.1, 53.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56, 52.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.7, 52.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.1, 52.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.9, 52.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.7, 52, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.3, 51.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.2, 51.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.2, 51, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82, 50.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.6, 50.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57, 49.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.1, 49.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.8, 49.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87.3, 49.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.4, 48.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.5, 47.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [86.1, 47.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [86.5, 47, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.2, 46.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.6, 44.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.1, 42.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68, 42.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.4, 42.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.3, 41.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.2, 41.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.8, 40.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.5, 40.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.2, 39.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.6, 39.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.3, 38.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.8, 37.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.6, 37.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.4, 36, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [83.3, 35.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.5, 34.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.6, 33.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85, 32.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36, 31.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.2, 31.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.5, 29.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [81, 28.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.9, 25, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.3, 24.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.2, 22.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.3, 22.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.7, 20.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    38: {
        '0': {
            count: 135,
            coords: [
                [29.7, 87.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.9, 87.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.3, 87, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.1, 85.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.7, 85.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.2, 82.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.3, 80.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.9, 80.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59, 78.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78, 77.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.1, 77.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.2, 77, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.1, 77, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.4, 76.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.1, 76.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.8, 75.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.8, 75, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.9, 74.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.9, 74.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80, 73.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73, 73.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.8, 73.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.9, 73.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.8, 72.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.6, 72.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.6, 72.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.6, 71.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.3, 71.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.2, 70.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58, 70.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.1, 70.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.6, 70, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.5, 69.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73, 68.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.7, 68.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.6, 68.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.6, 67.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.2, 66.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.3, 66.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.7, 66.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41, 65.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.8, 65.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.4, 65.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.4, 65.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75, 64.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.7, 64.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.6, 63.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.2, 63.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.8, 63.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.1, 62.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13.6, 62.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.9, 61.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.4, 61.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.6, 61, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.9, 60, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.2, 59.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.6, 59.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.3, 57.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.8, 57.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26, 57.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [84, 56.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.5, 56.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.7, 56.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.1, 56.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.9, 54.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.2, 53.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68, 53.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.6, 53.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.4, 53.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26, 50.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.8, 50.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.1, 50, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74, 48.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.4, 48.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.1, 47.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.1, 47.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57, 47.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.9, 46.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.2, 46.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.7, 46.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.7, 46.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.4, 44.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.1, 44.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.4, 44.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.6, 44.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48, 43.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.4, 42.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.8, 39.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.2, 38.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.2, 37.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.6, 36.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.8, 35.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.3, 34.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72, 34.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.7, 33.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.7, 32.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.6, 32.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.1, 32.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.5, 32, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.4, 31.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.5, 31.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.7, 29.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.2, 29.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.7, 28.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.4, 27.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.9, 27.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.3, 27.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.1, 26.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.8, 26.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.6, 24.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.1, 24.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.2, 24.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.1, 23.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.9, 22.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74, 21.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.5, 20.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.5, 20.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.6, 19.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.4, 19.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.5, 19.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.7, 19.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.4, 18.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.1, 18.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.1, 18.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.8, 17.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.8, 15.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.4, 15.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.1, 15.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.7, 14.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59, 13.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.8, 13.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.5, 13.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.2, 10, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.5, 9.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41, 8.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    85: {
        '0': {
            count: 129,
            coords: [
                [82.5, 74.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.5, 74.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.6, 73.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.1, 72.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.4, 72.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.3, 71, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.5, 70, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.1, 69.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.2, 69.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.2, 69.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.5, 69.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.5, 68.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.5, 67.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.4, 67.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [84.4, 66.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.1, 66.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.9, 66, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.6, 64.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.3, 64.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [83.7, 64.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [84.7, 64, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.4, 64, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.1, 63.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.2, 62.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.9, 60.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.6, 58.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.2, 57.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.5, 57.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.1, 57.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [81.5, 57.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.3, 57, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.2, 56.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74, 56.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85, 55.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [86.8, 55.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78, 54.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.7, 54.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.5, 54.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.6, 54, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.4, 53.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.8, 53.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.6, 52.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.7, 52.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [81.2, 52.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.8, 52, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [91, 51.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [81.2, 48.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.1, 48.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.7, 48.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.5, 47.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.6, 47.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.2, 47.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.4, 47, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.4, 46.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.6, 46, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [91, 45.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.3, 45.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.7, 45.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.6, 45.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.5, 45.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.5, 45.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66, 45, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.1, 44.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [89.4, 44.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.4, 44.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.4, 44.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.5, 44.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.7, 44.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80, 43.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.5, 43.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.6, 43.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.2, 43.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.7, 42.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.9, 42.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.1, 42, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.9, 41.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87.1, 41.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.6, 41.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.1, 41.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35, 40.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.3, 40.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.4, 40.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.7, 40.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [81.7, 39.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.1, 39.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.5, 39.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.4, 38.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.4, 38.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [84.2, 38.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.8, 38.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.1, 38, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.9, 37.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.2, 37.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.2, 37.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.3, 37.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79, 37.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87.7, 37.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.9, 36.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.6, 36.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.4, 36.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.6, 35.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.2, 35.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.2, 35.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.3, 35, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.6, 33.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.9, 33.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.3, 32.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.1, 32.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.4, 32, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.8, 31.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.3, 31.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.6, 31.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76, 31.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.2, 30.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60, 30.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.3, 30.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.2, 29.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42, 29, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.8, 29, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.5, 28.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.8, 28.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.4, 28.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.5, 27.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.2, 27.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.6, 27, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.3, 26.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.7, 26, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.8, 25.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.2, 24.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    3430: {
        '0': {
            count: 115,
            coords: [
                [46.3, 90.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.1, 89, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.5, 88.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.1, 88, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.9, 86.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.5, 86.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.5, 84.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.7, 84.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.2, 84.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.8, 83.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.3, 83.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37, 83, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.7, 82.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.6, 82.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.8, 82.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65, 81.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37, 80.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.1, 80.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.2, 80.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.5, 80.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.4, 80.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.4, 79.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.9, 79.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.1, 78.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.7, 77.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.9, 76.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66, 76.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.2, 76.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.8, 76.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.8, 76.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.4, 76.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.1, 75.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.9, 75.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.9, 75.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.2, 75.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.6, 75.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.7, 75, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.7, 74.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.1, 74.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.6, 74.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.4, 74.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.4, 73.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.2, 73.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.7, 73.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.4, 72.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.1, 72.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.4, 71.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.7, 71.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.7, 71.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.1, 70.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.2, 69.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.5, 69.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.2, 69.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.4, 69.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.3, 69.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37, 69.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.4, 69.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45, 68.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.7, 68.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.2, 67.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.5, 67.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.6, 67.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.4, 66.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.5, 66.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54, 66.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.8, 66.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.7, 66.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.3, 66.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.5, 65.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.3, 64.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.5, 64.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.6, 64.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.6, 64.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.4, 64.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.2, 64, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.6, 63.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.8, 63.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.1, 63.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.3, 62.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.2, 62.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.2, 62.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.4, 62.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.3, 62.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.7, 62.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48, 62.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.3, 61.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.2, 61.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.2, 61.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.1, 60.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.5, 60.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.1, 60.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.2, 60.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.3, 59.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.5, 59.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.9, 59.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.7, 58.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.8, 58.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71, 58.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.4, 58.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.6, 57.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.6, 57.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.9, 57.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.7, 57.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.3, 56.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.2, 56.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.1, 55.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.7, 54.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.8, 54.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.9, 54, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.3, 53.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.6, 51.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.4, 51.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.9, 49.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.1, 44.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.7, 40.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    12: {
        '0': {
            count: 110,
            coords: [
                [29.3, 88.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.7, 87.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.5, 85.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.3, 85.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50, 85, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78, 84.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.6, 84.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.2, 83.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.7, 82.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.8, 82.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.7, 82.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41, 82, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.6, 81.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39, 81.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.5, 81.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.6, 81.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.4, 80.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [83.3, 80.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.3, 80.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.2, 80.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.4, 79.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.8, 79.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.2, 79.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.5, 79, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.6, 78.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.6, 78.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.1, 78.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.9, 78.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39, 78.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.5, 78, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.7, 77.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.7, 77.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.9, 77.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.7, 77.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.7, 76.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52, 76.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.6, 75.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.9, 74.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.7, 74.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.4, 73.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.7, 73.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 73.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.1, 72.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.8, 72.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.6, 72.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.4, 71.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.5, 71, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.3, 71, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.7, 71, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.9, 70.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.8, 70.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.4, 69.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.9, 69.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.9, 68.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [89.6, 67.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.4, 67.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.3, 66.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.2, 66.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60, 65, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.3, 64.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.5, 63.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.1, 63.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.5, 63.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.2, 63.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.2, 63.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [89.2, 62, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87, 60.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.8, 59.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76, 59.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.8, 59.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.7, 59.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.5, 58.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.3, 58.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.3, 57.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.1, 56.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.4, 56.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.6, 55.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.6, 55.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.4, 54.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.2, 54.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.5, 54.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.5, 53.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.5, 52.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.6, 52.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.5, 52.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.1, 52.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.4, 51.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.1, 50.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.3, 50.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.5, 50.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.7, 50, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.2, 50, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.1, 49.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.2, 49.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.7, 49.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.6, 49.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.3, 49, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.8, 49, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.3, 48.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.8, 47.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.1, 47.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.5, 47.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.7, 47.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.7, 46.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.2, 44, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [81, 42.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65, 39.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.4, 37.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.8, 37.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.7, 36.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    4714: {
        '0': {
            count: 109,
            coords: [
                [45.4, 88.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.1, 88.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.4, 87.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.5, 87.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.4, 86, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48, 85, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.9, 84.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.2, 84.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.3, 84.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.3, 84.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.4, 84.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.9, 83.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.9, 83.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.4, 83.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.1, 83.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.3, 83.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.5, 83.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.8, 82.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.6, 82.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.9, 82.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66, 82.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.8, 82.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34, 82.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.4, 81.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.7, 81.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.9, 81.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.4, 81.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.5, 81.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.9, 80.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.4, 80.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.6, 80.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.8, 80.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.3, 79.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.1, 78.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.1, 76.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.8, 76.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.2, 76.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.9, 76.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.3, 75.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.7, 75.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.1, 75.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.7, 75.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.7, 74.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.7, 74.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.8, 74.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.9, 74.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.1, 74.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.9, 73.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.3, 73.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.3, 73.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.6, 73.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.2, 73.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.4, 73.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50, 71.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.3, 71.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.4, 71.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.8, 71.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.5, 71.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.1, 71.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.5, 71.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38, 70.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.6, 70.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.6, 70.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.3, 70.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23, 70.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.9, 70.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.1, 69.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.6, 69.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.2, 69.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.8, 69.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.3, 69.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.3, 69.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.9, 68.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.2, 68.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.5, 68.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.2, 68.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.2, 68.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.8, 67.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.9, 67.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.6, 65.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.8, 64.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.4, 64.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.3, 60, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.4, 58.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72, 45.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.8, 45.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.3, 42.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.7, 42.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.2, 41.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.2, 34.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.4, 33.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.4, 33.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.3, 32.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.4, 31.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.9, 31.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.4, 30.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.6, 29.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.2, 28.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.9, 28.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80, 27.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [81.7, 27.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [83.1, 26.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.3, 26.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.7, 25.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.2, 25.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [82.2, 25.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.7, 24.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.3, 23.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.4, 23.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    130: {
        '0': {
            count: 99,
            coords: [
                [53.2, 83.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.9, 81.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.7, 81.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62, 81, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.7, 81, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.5, 80.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.2, 79.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.7, 79.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.9, 79.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.2, 78.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56, 71.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.7, 69.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.5, 68.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.5, 68.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.3, 68.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.4, 67.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.5, 66.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.9, 66.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65, 64, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.7, 64, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.3, 62.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.4, 61.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66, 61.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.8, 61, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.7, 60.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.3, 60.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.1, 60.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.8, 60.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.3, 59.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50, 58.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.7, 58.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.8, 58.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.8, 58, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.6, 56.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.2, 56.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.1, 55.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.5, 55, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.8, 53.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.1, 53.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56, 52.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.8, 51.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.4, 50.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56, 50.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.1, 50, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50, 49.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.6, 49.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.6, 48, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49, 47.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.1, 46.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.1, 46.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.6, 44.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.1, 44, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.6, 43.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.3, 42.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.9, 41.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.2, 41, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.4, 38.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.4, 32.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.1, 31.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.8, 31.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.2, 30.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.7, 30.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.4, 29.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.6, 29.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.1, 29.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.8, 28, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.8, 27.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.3, 27.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.8, 27, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.2, 26.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43, 24.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.4, 23.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.9, 22.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.5, 22.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.4, 21.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.8, 19.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.7, 18.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.9, 18.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.5, 18.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.2, 18, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.6, 18, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.7, 18, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.2, 17.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.3, 17.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.6, 16.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.6, 16.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.4, 16.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.7, 16.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.5, 15.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41, 15.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.1, 15.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.5, 15.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.5, 15.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.7, 12.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.2, 11.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.6, 11.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.7, 6.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.1, 6.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.4, 6.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    3525: {
        '0': {
            count: 97,
            coords: [
                [41.5, 88.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.8, 86.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52, 85.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.7, 85.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.6, 84.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.9, 83.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.3, 82.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.8, 82, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41, 81.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.5, 79.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.2, 78.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.2, 76.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.7, 76, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.2, 74.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.5, 70.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.8, 70.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.7, 70.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.7, 70.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.2, 69, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.5, 66.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.8, 66.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.7, 64.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.6, 64.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.3, 64, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.3, 64, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.5, 63.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.1, 62.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.7, 62.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.2, 61.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.5, 61.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.7, 61.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.5, 61.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.6, 60, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.1, 59.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.3, 59.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.8, 58.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20.9, 58.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.9, 57.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [18.7, 57.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.5, 57.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.2, 56.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.2, 56.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.7, 55.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13.5, 54, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.5, 53.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35, 53, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.6, 52.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.2, 52, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.9, 52, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.5, 52, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.8, 52, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.6, 51.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.1, 51.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.1, 51.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.9, 49.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.5, 49.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.8, 49.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.7, 49, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.8, 48.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.9, 46.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.3, 46.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.3, 46, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50, 44.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.6, 43.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.6, 42.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.8, 42, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.1, 40.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.2, 38.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.3, 37.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.7, 36.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.7, 36.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.2, 35.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.9, 35.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48, 34.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.7, 34.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [20, 34.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.8, 33.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.6, 33.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43, 32.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.2, 31.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.4, 30.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.9, 30.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17, 28.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.1, 28.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.8, 26.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.3, 26.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.5, 26.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43, 25.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.4, 25.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.5, 24.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.4, 23.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.5, 21.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74, 20.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.2, 20.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.2, 19, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.5, 18.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.8, 13.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    4720: {
        '0': {
            count: 97,
            coords: [
                [56.4, 89.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.9, 89.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.3, 88.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.1, 82.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49, 81.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.5, 79.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.5, 78.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.4, 78, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.8, 76.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52, 76.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.1, 75.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.8, 73.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.9, 72.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52, 71.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.3, 71.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.4, 71.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.4, 70.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.2, 70.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.8, 70.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.3, 69, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.6, 68.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.4, 67.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.8, 67.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.4, 66.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.6, 65.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.4, 63.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.8, 61.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.8, 61.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48, 60.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.1, 59.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.9, 56.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.3, 56.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.1, 55.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.7, 55.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.5, 54.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.1, 54.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.4, 47.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71, 46.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.4, 45.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [71.2, 45.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34, 44.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.6, 44.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35, 43.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.8, 42.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.9, 41.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.1, 39.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.9, 38.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.6, 37.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33, 37.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.4, 37, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.5, 36.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.8, 35.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.4, 35.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.4, 35.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57, 35.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.5, 35.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.4, 34.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.7, 33.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.2, 32.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.6, 32.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.1, 32.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.6, 32.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.4, 31.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.2, 31.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.5, 30.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.4, 30.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40, 29.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.1, 29.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.4, 28.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.5, 27.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.5, 27.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.1, 27.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.5, 26.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.9, 26.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.3, 26.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.6, 26.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.9, 25.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.8, 25.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.5, 24.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.2, 24.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41, 24, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57, 23.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.3, 22.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.4, 22.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53, 22.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.2, 22, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.4, 21.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.5, 21.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.5, 21.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.3, 19.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49, 18.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.1, 18.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.3, 17.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.7, 16.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.3, 16.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.6, 15.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.2, 14.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    1: {
        '0': {
            count: 96,
            coords: [
                [46.9, 66.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.6, 65.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.2, 63.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.1, 63.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.2, 62.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [84.8, 62.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.2, 62, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.9, 61.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.4, 60.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.5, 60.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.7, 60.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.9, 59.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.7, 59.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.1, 59.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.3, 59.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.9, 59, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.6, 58.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.1, 58.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [83, 58.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45, 58, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78, 57.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.6, 57.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [74.4, 57.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.6, 57.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39, 56.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.3, 56.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.7, 56.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.9, 56.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.4, 56.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.5, 56.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.2, 55.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.7, 55.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.1, 55.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.4, 55.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32, 55.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [76.5, 55.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.9, 55.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.2, 54.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.1, 54.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [72.5, 54.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.6, 54.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [89.9, 53.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.9, 53.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.8, 52.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.5, 52.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40, 52.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.9, 52.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.4, 52.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.7, 52.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.8, 52.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.2, 51.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.5, 51.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.9, 51.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.8, 51, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49, 51, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.6, 50.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.2, 50, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.7, 49.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.2, 49.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.5, 49.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.7, 49.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.1, 48.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.5, 48, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48, 47.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34, 47.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.1, 46.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.1, 46.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.5, 46.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [88.7, 45.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.3, 45, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.5, 44.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.4, 44.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31, 43.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.9, 43.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.8, 42.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.1, 41, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.5, 39.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87.2, 39.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 39.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.1, 39.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.9, 38.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [89.8, 37.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.4, 37, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.4, 36.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.9, 36.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [85.8, 36.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.8, 35.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.2, 34.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.7, 34.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.4, 33.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.3, 33.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.3, 33.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.7, 32.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.5, 32.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [87.6, 32.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.5, 29.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    215: {
        '0': {
            count: 92,
            coords: [
                [34.7, 79.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.2, 78.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34, 74.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.7, 73.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.4, 73, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.5, 73, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.2, 71.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.1, 71.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35, 71.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52, 71.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.7, 70.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.8, 70.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.1, 70, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.2, 68.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.4, 68.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.6, 68.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.3, 66.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.4, 64.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.7, 64.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.7, 62.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34, 61.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.1, 61.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.4, 60.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.1, 60.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.9, 59.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.5, 59.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.7, 58.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.4, 57.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.2, 55, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.8, 54.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.3, 54.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.8, 53.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.9, 51.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.8, 51.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.8, 50.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61, 50.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.9, 47.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.5, 47.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59, 46.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.7, 45, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.7, 44.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.3, 43.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.4, 43.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.9, 42.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.7, 41.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.9, 41.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.4, 40.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.5, 38.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.4, 38, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.6, 36.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.9, 36.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.5, 35.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.4, 35.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.4, 34.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.4, 33.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.1, 33.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.4, 32.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58, 32.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.1, 32.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.1, 32, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.5, 30.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.3, 30.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.1, 30.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.5, 29.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.5, 27.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.4, 27.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.2, 26.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.1, 25.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.8, 24.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [62.6, 22.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.2, 21.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.6, 21.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31, 21.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.4, 21, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.4, 20, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.5, 18.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.3, 18.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.6, 18, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.6, 16.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.3, 16.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.7, 15.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.5, 15.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.8, 14.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.7, 12.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.1, 11.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.8, 11.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39, 9.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.5, 9.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.3, 9.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 9.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.7, 8.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51.9, 7.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    3433: {
        '0': {
            count: 92,
            coords: [
                [32.8, 86.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.2, 85.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.5, 85, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.3, 83.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.7, 83, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.7, 83, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.8, 79.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.4, 78.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.1, 78.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.6, 76.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.2, 76, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.8, 74.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.3, 71.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.5, 69.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.5, 69.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.6, 68.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.4, 68, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.3, 67.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.1, 67.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.6, 64.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.1, 64, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.2, 63.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.4, 62.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.6, 61.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.5, 60.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.9, 59.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.7, 58.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.6, 57.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.1, 56.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.4, 54.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.8, 54.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.8, 54.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.3, 53.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.1, 53.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.7, 53.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57, 53.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.6, 52.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.8, 52.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.3, 51.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.6, 51.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.1, 51.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.1, 49.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.4, 48.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.9, 48.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.1, 48.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.3, 47.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.7, 47.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.6, 47, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.2, 46.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.6, 46.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.6, 46.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.8, 46.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [70.1, 45.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.6, 45.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [15.1, 45.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [65.9, 44.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.3, 44.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [73.2, 43.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.2, 40.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [75.3, 40.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.7, 40.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.3, 38.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.2, 38.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.8, 38.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [69.9, 36.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.7, 36.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.4, 34.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.2, 34.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.2, 34, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [79.1, 33.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32, 30.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.5, 28.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.3, 27.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.6, 26.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [77.1, 23.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54, 22.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.1, 22.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.4, 21.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.7, 21, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.4, 20, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [66.1, 19.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.1, 19.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.7, 18.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [80.5, 18.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43, 18, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.9, 17.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.5, 15.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.9, 13.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.2, 13.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [78.1, 11.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [64.9, 10.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.7, 5.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    3524: {
        '0': {
            count: 83,
            coords: [
                [17.6, 89.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.5, 89.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [13.1, 87.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.7, 86.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [11.2, 85.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35.9, 84.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.4, 83.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [14.2, 82.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.2, 82.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [17.1, 81.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.1, 80.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.1, 79.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.8, 78.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [16.3, 77.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [19.2, 77, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.7, 76.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.2, 76.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.8, 76.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.9, 75.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.4, 74.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.4, 74.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.7, 74.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.2, 73.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.2, 73.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [23.8, 73.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.5, 73.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.2, 73, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.9, 72.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.5, 72.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [26.6, 71.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.9, 71.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [21.9, 70.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.8, 70.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [22.6, 69.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.4, 68.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.4, 68.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.2, 66.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.7, 65.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.3, 64.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.9, 64.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [24.4, 61, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [25.1, 59.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [57.7, 56.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.6, 55.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.8, 55.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34, 53.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.2, 52.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.6, 52, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.3, 51.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.4, 49.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27, 48, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.2, 46.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.7, 43.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.7, 42.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.2, 42.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.7, 41.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.8, 40.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [55.9, 40.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.1, 38.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.6, 38, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [53.4, 37.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.8, 29.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49, 23.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.7, 21, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.2, 20.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.4, 19.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [51, 17.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.7, 16.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.5, 16.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.4, 15.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47, 15.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.9, 15, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.3, 14.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.4, 14.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.8, 14.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.5, 14, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.5, 13.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.4, 13.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.5, 13, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [48.9, 12.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50, 11.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.7, 10.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.6, 7.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    },
    40: {
        '0': {
            count: 72,
            coords: [
                [32.5, 81.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.5, 78.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.3, 78.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.7, 77.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.2, 77.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [67.1, 76.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [68.7, 75.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [58.6, 75.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.5, 74, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.7, 73.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.7, 73.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [54.5, 72.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.2, 71.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [47.7, 71.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [49.8, 70.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.6, 68, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31.4, 64.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35, 61.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.6, 60.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.9, 59.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.9, 56.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.3, 52.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.5, 50.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.8, 49.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.7, 49.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.7, 49.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.7, 48.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.5, 47.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [37.1, 47.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.6, 46.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31, 46.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [31, 46.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.2, 46, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [34.3, 45.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [29.2, 45.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.9, 45.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.1, 45.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.3, 45.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.6, 43.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [42.5, 43.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32.6, 42.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.1, 42.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [35, 40.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.7, 39.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43, 39.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [40.9, 37.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [38.1, 37, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [27.8, 35.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [63.6, 33.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [28.2, 33.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [30.8, 31.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [32, 27.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [60.9, 26.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.8, 25.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [59.2, 24, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44, 23.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [33.8, 23.8, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [61.1, 22.9, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.2, 22.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [36.2, 21.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [45.5, 20.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46.7, 19.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [44.8, 19.2, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46, 18.5, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [39.9, 16, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [50.1, 13.1, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [41.1, 13, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [46, 11.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [43.5, 11.6, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [52.3, 11.4, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56.5, 11.3, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }], [56, 7.7, {
                    label: '$2$1<br><div class=q0><small>Respawn: 30sec</small><br><small>Phase: 1</small><br>$3</div>',
                    type: '0'
                }]]
        }
    }
};

axios.get(url + "2714").then(res => {
    console.log(res.data)
});


// data.forEach((row) => {
//     console.log(row.id + ",")
// });

